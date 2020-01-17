defmodule OpOtp.Permit do
  @moduledoc """
  Business Logic of a Permit.
  """
  alias OpOtp.Commands.RequirePermit
  alias __MODULE__

  defstruct ~w(
    id
    submitted_by
    notes
    authority
    status
    rejection_reason
    required_on
    submitted_on
    approved_on
    rejected_on
  )a

  def new(%RequirePermit{} = cmd) do
    %Permit{
      id: cmd.permit_id,
      notes: cmd.notes,
      authority: cmd.authority,
      status: :needs_submission,
      required_on: DateTime.utc_now(),
    }
  end

  ## Rules

  def can_submit?(%Permit{status: :needs_submission, authority: authority}) when not is_nil(authority) do
    :ok
  end

  def can_reject?(%Permit{status: :submitted}) do
    :ok
  end

  def can_reject?(%Permit{status: :rejected}) do
    {:error, "Already rejected!"}
  end

  def can_approve?(%Permit{status: :submitted}) do
    :ok
  end

  def can_approve?(%Permit{status: _}) do
    {:error, "Must be submitted to be approved!"}
  end

  ## State Transitions

  def submit(%Permit{status: :needs_submission} = permit) do
    %Permit{permit | status: :submitted, submitted_on: DateTime.utc_now()}
  end

  def reject(%Permit{status: :submitted} = permit, rejection_reason) do
    %Permit{permit | status: :rejected, rejected_on: DateTime.utc_now(), rejection_reason: rejection_reason}
  end

  def approve(%Permit{status: :submitted} = permit) do
    %Permit{permit | status: :submitted, approved_on: DateTime.utc_now()}
  end
end
