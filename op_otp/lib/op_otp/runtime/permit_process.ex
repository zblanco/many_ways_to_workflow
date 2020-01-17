defmodule OpOtp.Runtime.PermitProcess do
  @moduledoc """
  Genserver to manage the lifecycle of the permit state.

  Dynamically Supervised and uses the Permit module for logic.
  """
  use GenServer, restart: :transient
  alias OpOtp.Runtime.PermitSupervisor
  alias OpOtp.{
    Permit,
    Permitting,
    Messaging,
    Persistence,
    Query,
  }
  alias OpOtp.Commands.{
    RequirePermit,
    RejectPermit,
  }
  alias OpOtp.Events.{
    PermitRequired,
    PermitRejected,
    PermitSubmitted,
    PermitApproved,
  }

  @default_timeout :timer.minutes(30)

  def via(permit_id) when is_binary(permit_id) do
    {:via, Registry, {OpOtp.WorkflowRegistry, {__MODULE__, permit_id}}}
  end

  def child_spec(permit_id) do
    %{
      id: {__MODULE__, permit_id},
      start: {__MODULE__, :start_link, [permit_id]},
      restart: :temporary,
    }
  end

  def start_link(permit_id) do
    GenServer.start_link(
      __MODULE__,
      permit_id,
      name: via(permit_id)
    )
  end

  def start(permit_id) do
    DynamicSupervisor.start_child(
      PermitSupervisor,
      {__MODULE__, permit_id}
    )
  end

  def stop(permit_id) do
    GenServer.stop(via(permit_id))
  end

  def init(permit_id) when is_binary(permit_id) do
    # quick init work here
    # init will block until finished, so doing expensive work here isn't ideal
    # delegating to the handle_continue callback allows startup to proceed with a guarantee handle_continue
    # is finished first before additional messages are processed by the genserver
    {:ok, permit_id, {:continue, :init}}
  end

  # handle_continue is where we can do something potentially more expensive like rebuilding our state from the database
  def handle_continue(:init, permit_id) do
    case Query.fetch_permit(permit_id) do
      {:ok, permit} -> {:noreply, permit}
      {:error, _}   -> {:noreply, permit_id}
    end
  end

  def handle_command(%RequirePermit{} = cmd) do
    start(cmd.permit_id)
    call(cmd.permit_id, cmd)
  end

  def handle_command({cmd, permit_id}) do
    call(permit_id, cmd)
  end

  def handle_command(cmd) do
    call(cmd.permit_id, cmd)
  end

  def get_state(permit_id) do
    call(permit_id, :get_state)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(%RequirePermit{} = cmd, _from, permit_id) when is_binary(permit_id) do
    permit = Permit.new(cmd)
    Messaging.publish(PermitRequired.new(permit), Permitting.topic())

    {:reply, :ok, Persistence.upsert(permit), @default_timeout}
  end

  def handle_call(:submit_permit, _from, %Permit{} = permit) do
    permit =
      case Permit.can_submit?(permit) do # check rules
        :ok -> # if ok we can trigger side effects and make state transitions
          permit = Permit.submit(permit)
          Messaging.publish(PermitSubmitted.new(permit), Permitting.topic(permit.id))
          permit
        :error -> permit
      end

    {:reply, :ok, Persistence.upsert(permit), @default_timeout} # return persisted version
  end

  def handle_call(%RejectPermit{} = cmd, _from, %Permit{} = permit) do
    permit =
      case Permit.can_reject?(permit) do
        :ok ->
          permit = Permit.reject(permit, cmd.rejection_reason)
          Messaging.publish(PermitRejected.new(permit), Permitting.topic(permit.id))
          permit
        :error -> permit
      end

    {:reply, :ok, Persistence.upsert(permit), @default_timeout}
  end

  def handle_call(:approve_permit, _from, %Permit{} = permit) do
    permit =
      case Permit.can_reject?(permit) do
        :ok ->
          permit = Permit.approve(permit)
          Messaging.publish(PermitApproved.new(permit), Permitting.topic(permit.id))
          permit
        :error -> permit
      end

    {:reply, :ok, Persistence.upsert(permit), @default_timeout}
  end

  # Helper for handle_call messages that starts or restarts the Permit Process if necessary.
  # A similar function for `cast` could be written.
  defp call(permit_id, command) do
    pid =
      case PermitSupervisor.find_permit_process(permit_id) do
        nil ->
          {:ok, pid} = start(permit_id)
          pid
        pid -> pid
      end

    GenServer.call(pid, command)
  end
end
