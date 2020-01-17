defmodule OpOtp.Commands.RequirePermit do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w(authority notes)a
  @primary_key false
  embedded_schema do
    field :permit_id, :string
    field :authority, :string
    field :notes, :string
  end

  def new(attrs) do
    cmd = changeset(attrs)
    case cmd.valid? do
      true  -> {:ok, apply_changes(cmd)}
      false -> cmd
    end
  end

  def new(attrs, form: true), do: form_changeset(attrs)

  defp form_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required)
    |> validate_required(@required)
  end

  defp changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required)
    |> put_change(:permit_id, Ecto.UUID.generate())
    |> validate_required(@required)
  end
end
