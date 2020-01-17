defmodule OpOtp.Events.PermitApproved do
  alias OpOtp.Permit
  defstruct ~w(
    permit_id
    approved_on
  )a

  def new(%Permit{} = permit) do
    %__MODULE__{permit_id: permit.id, approved_on: permit.approved_on}
  end
end
