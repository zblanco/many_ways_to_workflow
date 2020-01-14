defmodule OpOtp.Permit do
  @moduledoc """

  """
  defstruct ~w(
    id
    description
    authority
    status
    created_on
    started_on
    submitted_on
    approved_on
    rejected_on
  )a

  def new(params \\ %{}) do
    struct!(__MODULE__, params) |> assign_id()
  end

  defp assign_id(permit),
    do: Map.put(permit, :id, UUID.uuid4())

  ## Rules

  ## State Transitions / Reductions
end
