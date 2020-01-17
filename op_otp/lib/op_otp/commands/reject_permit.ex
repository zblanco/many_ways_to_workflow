defmodule OpOtp.Commands.RejectPermit do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w(permit_id rejection_reason)a
  @primary_key false
  embedded_schema do
    field :permit_id, :string
    field :rejection_reason, :string
  end

  def new(attrs) do
    cmd = changeset(attrs)
    case cmd.valid? do
      true  -> {:ok, apply_changes(cmd)}
      false -> cmd
    end
  end

  def new(attrs, form: true), do: changeset(attrs)

  defp changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
