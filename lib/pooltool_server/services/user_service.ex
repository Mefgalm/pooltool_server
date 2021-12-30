defmodule PooltoolServer.UserService do
  import Ecto.Query
  alias PooltoolServer.Entity.User
  alias PooltoolServer.Repo
  alias PooltoolServer.UserDomain
  alias PooltoolServer.Email
  alias PooltoolServer.Mailer

  @spec sign_up(String.t(), String.t()) :: {:ok, %User{}} | Result.error()
  def sign_up(email, password) do
    with {:ok, params, email_confirm_token} <-
           UserDomain.sign_up(email, password, DateTime.utc_now()),
         {:ok, user} <-
           %User{}
           |> User.insert_changeset(params)
           |> Repo.insert()
           |> Repo.handle_changset_error() do
      Mailer.deliver_now!(Email.confirm_email(email, email_confirm_token))

      {:ok, user}
    end
  end

  @spec sign_in(String.t(), String.t()) :: {:ok, map} | Result.error()
  def sign_in(email, password) do
    user = Repo.get_by(User, email: email)

    with :ok <- UserDomain.sign_in(user, password) do
      {:ok, user}
    end
  end

  @spec forgot_password(String.t()) :: :ok
  def forgot_password(email) do
    if Repo.exists?(from u in User, where: u.email == ^email) do
      forgot_password_token = UserDomain.generate_forgot_password_token(email, DateTime.utc_now())
      Mailer.deliver_now!(Email.forgot_password(email, forgot_password_token))
    end

    :ok
  end

  @spec confirm_email!(String.t()) :: no_return
  def confirm_email!(token) do
    {:ok, email} = UserDomain.verify_and_get_email_confirmation(token)

    Repo.get_by(User, email: email)
    |> User.change_email_confirmed(true)
    |> Repo.update()
  end

  @spec reset_password(String.t(), String.t()) :: {:ok, %User{}} | Result.error()
  def reset_password(new_password, token) do
    {:ok, email} = UserDomain.verify_and_get_forgot_password(token)

    Repo.get_by(User, email: email)
    |> User.change_set_new_password(new_password)
    |> Repo.update()
    |> Repo.handle_changset_error()
  end
end
