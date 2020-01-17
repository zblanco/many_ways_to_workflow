defmodule OpOtp.Permitting do
  @moduledoc """
  Interface for permitting concerns.
  """
  alias OpOtp.Messaging
  alias OpOtp.Runtime.PermitProcess
  alias OpOtp.Commands.{
    RequirePermit,
    RejectPermit,
  }

  def topic(), do: inspect(__MODULE__)
  def topic(permit_id), do: "#{topic()}-#{Permit}-#{permit_id}"

  def subscribe(), do: Messaging.subscribe(topic())
  def subscribe(permit_id), do: Messaging.subscribe(topic(permit_id))

  def require_permit(params \\ %{}) do
    with {:ok, cmd} <- RequirePermit.new(params) do
      PermitProcess.handle_command(cmd)
    end
  end

  def submit_permit(permit_id),
    do: PermitProcess.handle_command({:submit, permit_id})

  def approve_permit(permit_id),
    do: PermitProcess.handle_command({:approve, permit_id})

  def reject_permit(params \\ %{}) do
    with {:ok, cmd} <- RejectPermit.new(params) do
      PermitProcess.handle_command(cmd)
    end
  end

end
