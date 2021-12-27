defmodule PooltoolServer.UserDomain do
  alias PooltoolServer.Entity.User

  @doc ~S"""
    Sign up
  """
  @spec sign_up(String.t(), String.t(), DataTime.t()) :: {:ok, map} | Result.error()
  def sign_up(email, password, utc_now) do
    {:ok,
     %{
       email: email,
       password: password,
       email_confirmed: false,
       created_at: utc_now
     }}
  end

  @doc ~S"""
    SignIn

    ## Examples
      iex> PooltoolServer.UserDomain.sign_in(nil, "12345678Aa!")
      {:error, :invalid_email_or_password, "Invalid email or password"}

      iex> PooltoolServer.UserDomain.sign_in(%PooltoolServer.Entity.User{password_hash: "$pbkdf2-sha512$1$a2Xf41B4MJsYKi9NYyOM8w$KFgmieUuhUdLThIYMbozHvVatbytOdfk36.KC90oIW1vidrgmHSSoNkzxYSfpWpgmBY.BfDO4xWA4XBuSFrtyw"}, "12345678Aa!")
      :ok

      iex> PooltoolServer.UserDomain.sign_in(%PooltoolServer.Entity.User{password_hash: "$pbkdf2-sha512$1$a2Xf41B4MJsYKi9NYyOM8w$KFgmieUuhUdLThIYMbozHvVatbytOdfk36.KC90oIW1vidrgmHSSoNkzxYSfpWpgmBY.BfDO4xWA4XBuSFrtyw"}, "12345678Aa!___")
      {:error, :invalid_email_or_password, "Invalid email or password"}

  """

  @spec sign_in(%User{} | nil, String.t()) :: :ok | Result.error()
  def sign_in(user, password) do
    invalid_email_or_password_error =
      Result.error!(:invalid_email_or_password, "Invalid email or password")

    case user do
      nil ->
        invalid_email_or_password_error

      user ->
        if Pbkdf2.verify_pass(password, user.password_hash) do
          :ok
        else
          invalid_email_or_password_error
        end
    end
  end
end
