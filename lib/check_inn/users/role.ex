defmodule CheckInn.Users.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
