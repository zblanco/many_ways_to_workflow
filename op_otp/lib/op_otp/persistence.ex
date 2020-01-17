defmodule OpOtp.Persistence do
  @moduledoc """
  Responsible for persisting data.

  We're cheating for now and just returning the permit. Don't tell anyone.
  """
  alias OpOtp.Permit

  def upsert(%Permit{} = permit) do
    permit
  end
end
