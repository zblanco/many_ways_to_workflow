defmodule OpOtp.Runtime.PermitSupervisor do
  @moduledoc """
  Dynamic Supervision capabilities for the PermitProcess's lifecycle implementation.
  """
  use DynamicSupervisor

  alias OpOtp.Runtime.PermitProcess

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def find_permit_process(permit_id) do
    permit_id
    |> PermitProcess.via()
    |> GenServer.whereis()
  end

  def is_permit_process_running?(permit_id) do
    case find_permit_process(permit_id) do
      nil          -> false
      _pid_or_name -> true
    end
  end

  def stop_permit_process(permit_id) do
    case find_permit_process(permit_id) do
      nil -> {:error, :process_not_active}
      {_, _node} -> :error
      pid -> DynamicSupervisor.terminate_child(__MODULE__, pid)
    end
  end
end
