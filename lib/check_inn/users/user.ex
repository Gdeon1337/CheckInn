defmodule CheckInn.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt
  alias CheckInn.Users.Role

  @derive {Jason.Encoder, only: [:id, :login]}
  schema "users" do
    field :login, :string
    field :password, :string
    field :raw_password, :string, virtual: true 

    belongs_to :role, Role
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:login, :raw_password, :role_id])
    |> validate_required([:login, :raw_password, :role_id])
    |> unique_constraint(:login)
    |> hash_password
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{raw_password: raw_password}} = changeset) do
    changeset |> put_change(:password, Bcrypt.hash_pwd_salt(raw_password))
  end

  defp hash_password(changeset) do
    changeset
  end
end
