defmodule PooltoolServer.UserDomain do
  alias DateTime.Extensions, as: DateTimeExt
  alias PooltoolServer.Entity.User
  alias PooltoolServer.Jwt

  @email_confirmation_type "email_confirmation"
  @forgot_password_type "forgot_password"
  @email_token_hours_valid Application.fetch_env!(:pooltool_server, :email_token_hours_valid)

  @spec generate_email_confirm_token(String.t(), DateTime.t()) :: String.t()
  defp generate_email_confirm_token(email, utc_now) do
    claims = %{
      "email" => email,
      "type" => @email_confirmation_type,
      "exp" => utc_now |> DateTimeExt.add_hours_to_unix(@email_token_hours_valid)
    }

    Jwt.generate_and_sign!(claims)
  end

  defp verify_and_get_claims(token, type) do
    with {:ok, %{"type" => ^type} = claims} <- Jwt.verify_and_validate(token) do
      {:ok, claims}
    else
      _ -> Result.error!(:invalid_token, "Invalid token")
    end
  end

  @spec sign_up(String.t(), String.t(), DataTime.t()) :: {:ok, map, String.t()} | Result.error()
  def sign_up(email, password, utc_now) do
    {:ok,
     %{
       email: email,
       password: password,
       email_confirmed: false,
       created_at: utc_now
     }, generate_email_confirm_token(email, utc_now)}
  end

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

  @spec verify_and_get_email_confirmation(String.t()) :: {:ok, String.t()} | Result.error()
  def verify_and_get_email_confirmation(token) do
    with {:ok, %{"email" => email}} <- verify_and_get_claims(token, @email_confirmation_type) do
      {:ok, email}
    end
  end

  @spec generate_forgot_password_token(String.t(), DateTime.t()) :: String.t()
  def generate_forgot_password_token(email, utc_now) do
    claims = %{
      "type" => @forgot_password_type,
      "exp" => utc_now |> DateTimeExt.add_hours_to_unix(@email_token_hours_valid),
      "email" => email
    }

    Jwt.generate_and_sign!(claims)
  end

  @spec verify_and_get_forgot_password(String.t()) :: {:ok, map()} | Result.error()
  def verify_and_get_forgot_password(token) do
    with {:ok, %{"email" => email}} <- verify_and_get_claims(token, @forgot_password_type) do
      {:ok, email}
    end
  end
end
