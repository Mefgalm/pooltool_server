defmodule PooltoolServer.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :email_confirmed, :boolean, null: false
      add :created_at, :utc_datetime, null: false
    end
    create unique_index(:users, [:email])
  end
end
