defmodule OpOtp.Events.PermitRejected do
  alias OpOtp.Permit
  defstruct ~w(
    permit_id
    rejected_on
    rejection_reason
  )a

  def new(%Permit{} = permit) do
    %__MODULE__{permit_id: permit.id, rejected_on: permit.rejected_on, rejection_reason: permit.rejection_reason}
  end
end
