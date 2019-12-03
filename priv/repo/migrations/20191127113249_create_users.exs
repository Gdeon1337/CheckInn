defmodule CheckInn.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :title, :string

      timestamps()
    end

    create table(:users) do
      add :login, :string
      add :password, :string
      add :role_id, references(:roles, on_delete: :nothing)
      
      timestamps()
    end

    create unique_index(:users, [:login])
    create index(:users, [:role_id])
  end
end
