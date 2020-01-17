defmodule OpOtp.Query do
  @moduledoc """
  Responsible for fetching data.
  """
  def fetch_permit(_permit_id) do
    {:error, "Nothing found"}
  end
end
