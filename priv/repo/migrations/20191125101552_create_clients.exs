defmodule CheckInn.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :ip, :string

      timestamps()
    end

  end
end
