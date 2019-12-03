defmodule CheckInn.Clients.Client do
  use Ecto.Schema
  import Ecto.Changeset
  alias CheckInn.Clients.Inn

  schema "clients" do
    field :ip, :string
    
    has_many :inns, Inn
    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:ip])
    |> validate_required([:ip])
  end
end
