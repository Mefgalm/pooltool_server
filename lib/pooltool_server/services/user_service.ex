defmodule PooltoolServer.UserService do
  alias PooltoolServer.Entity.User
  alias PooltoolServer.Repo
  alias PooltoolServer.UserDomain
  alias PooltoolServer.Email
  alias PooltoolServer.Mailer

  @spec sign_up(String.t(), String.t()) :: any
  def sign_up(email, password) do
    with {:ok, params} <- UserDomain.sign_up(email, password, DateTime.utc_now()) do
      %User{}
      |> User.insert_changeset(params)
      |> Repo.insert()
      |> Repo.handle_changset_error()
    end
  end

  @spec sign_in(String.t(), String.t()) :: {:ok, map} | Result.error()
  def sign_in(email, password) do
    user = Repo.get_by(User, email: email)

    Email.welcome_email(email)   # Create your email
    |> Mailer.deliver_now!() # Send your email

    with :ok <- UserDomain.sign_in(user, password) do
      {:ok, %{user: user, token: "JWT token"}}
    end
  end
end
