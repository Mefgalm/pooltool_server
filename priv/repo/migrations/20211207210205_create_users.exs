defmodule PooltoolServer.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password_hash, :string
      add :created_at, :utc_datetime
    end
    create unique_index(:users, [:email])
  end
end
