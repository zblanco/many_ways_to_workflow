defmodule OpOtp.Events.PermitRequired do
  alias OpOtp.Permit
  defstruct ~w(
    permit_id
    required_on
    authority
  )a

  def new(%Permit{} = permit) do
    %__MODULE__{permit_id: permit.id, required_on: permit.required_on, authority: permit.authority}
  end
end
