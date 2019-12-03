defmodule CheckInn.Repo.Migrations.CreateInns do
  use Ecto.Migration

  def change do
    create table(:inns) do
      add :number, :string
      add :date_time, :timestamp
      add :correctness, :boolean
      add :client_id, references(:clients, on_delete: :nothing)
      timestamps()
    end

    create index(:inns, [:client_id])
  end
end
