defmodule OpOtp.Events.PermitSubmitted do
  alias OpOtp.Permit
  defstruct ~w(
    permit_id
    submitted_on
  )a

  def new(%Permit{} = permit) do
    %__MODULE__{permit_id: permit.id, submitted_on: permit.submitted_on}
  end
end
