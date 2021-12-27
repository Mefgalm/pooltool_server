defmodule PooltoolServer.UserService do
  alias PooltoolServer.Entity.User
  alias PooltoolServer.Repo
  alias PooltoolServer.Jwt
  alias PooltoolServer.UserDomain
  alias PooltoolServer.Email
  alias PooltoolServer.Mailer
  alias PooltoolServer.EmailConfirmationService

  @spec sign_up(String.t(), String.t()) :: any
  def sign_up(email, password) do
    with {:ok, params} <- UserDomain.sign_up(email, password, DateTime.utc_now()),
         {:ok, user} <-
           %User{}
           |> User.insert_changeset(params)
           |> Repo.insert()
           |> Repo.handle_changset_error() do
      email_token = EmailConfirmationService.generate_email_confirm_token(email)

      Mailer.deliver_now!(Email.confirm_email(email, email_token))

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

  def confirm_email(token) do
    with {:ok, email} <- EmailConfirmationService.get_email(token) do
      Repo.get_by(User, email: email)
      |> User.change_email_confirmed(true)
      |> Repo.update()
    end
  end
end
