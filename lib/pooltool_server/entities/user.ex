defmodule PooltoolServer.Entity.User do
  use Ecto.Schema
  import Ecto.Changeset
  import PooltoolServer.Validations

  @derive {Jason.Encoder, except: [:__meta__]}

  schema "users" do
    field(:email, :string)
    field(:password_hash, :string)
    field(:created_at, :utc_datetime)
  end

  def create_changeset(user, params \\ %{}) do
    fields = ~w(email password_hash created_at)a

    user
    |> cast(params, fields)
    |> validate_required(fields)
    |> validate_email(:email)
    |> unique_constraint(:email)
  end
end
