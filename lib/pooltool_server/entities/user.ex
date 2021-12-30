defmodule PooltoolServer.Entity.User do
  use Ecto.Schema
  import Ecto.Changeset
  import PooltoolServer.Validations

  @derive {Jason.Encoder, except: [:__meta__, :password_hash]}

  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string, redact: true)
    field(:email_confirmed, :boolean)
    field(:created_at, :utc_datetime)
  end

  def insert_changeset(user, params \\ %{}) do
    fields = ~w(email password email_confirmed created_at)a

    user
    |> cast(params, fields)
    |> validate_required(fields)
    |> validate_email(:email)
    |> validate_password()
    |> put_pass_hash()
    |> unique_constraint(:email)
  end

  defp validate_password(changeset) do
    validate_format(
      changeset,
      :password,
      ~r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()№:?[\]\-_~/\.,])[a-zA-Z\d!@#$%^&*()№:?[\]\-_~/\.,]{8,}$",
      message:
        "Password should be at least 8 characters and contains one lowercase, one uppercase and one special character."
    )
  end

  defp put_pass_hash(changeset) do
    password = get_field(changeset, :password)
    IO.inspect(password)
    put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))
  end

  def change_email_confirmed(user, email_confirmed) do
    change(user, email_confirmed: email_confirmed)
  end

  def change_set_new_password(user, new_password) do
    user
    |> change(password: new_password)
    |> validate_password()
    |> put_pass_hash()
  end
end
