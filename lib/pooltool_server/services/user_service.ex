defmodule PooltoolServer.UserService do
  import Ecto.Query
  alias PooltoolServer.Entity.User
  alias PooltoolServer.Repo

  @spec sign_up(String.t, String.t) :: any
  def sign_up(email, password) do
    %User{}
    |> User.create_changeset(%{email: email, password_hash: password, created_at: DateTime.utc_now()})
    |> Repo.insert()
  end
end
