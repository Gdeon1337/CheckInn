defmodule CheckInn.Clients.Inn do
  use Ecto.Schema
  import Ecto.Changeset
  alias CheckInn.Clients.Client

  schema "inns" do
    field :number, :string
    field :date_time, :naive_datetime
    field :correctness, :boolean
    belongs_to :client, Client
    timestamps()
  end

  @doc false
  def changeset(inn, attrs) do
    inn
    |> cast(attrs, [:number, :correctness, :client_id])
    |> validate_required([:number, :correctness, :client_id])
    |> init_date_time
  end

  def init_date_time(%Ecto.Changeset{valid?: true} = changeset) do
    date = NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
    changeset
      |> put_change(:date_time, date)
  end

  def init_date_time(changeset) do
    changeset
  end

end
