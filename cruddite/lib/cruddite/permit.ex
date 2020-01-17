defmodule Cruddite.Permit do
  use Ecto.Schema

  schema "permits" do
    field :status, :string
    field :notes, :string

    field :submitted_on, :utc_datetime_usec
    field :approved_on, :utc_datetime_usec
    field :rejected_on, :utc_datetime_usec

    belongs_to :design, Design
    belongs_to :project, Project
    belongs_to :authority, Authority

    timestamps()
  end
end
