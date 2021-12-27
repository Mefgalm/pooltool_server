defmodule PooltoolServer.EmailConfirmationService do
  alias PooltoolServer.Jwt

  @spec hours_to_seconds(pos_integer()) :: pos_integer()
  defp hours_to_seconds(h), do: h * 60 * 60

  def generate_email_confirm_token(email) do
    email_token_hours_valid = Application.fetch_env!(:pooltool_server, :email_token_hours_valid)

    claims = %{
      "email" => email,
      "type" => :email_confirmation,
      "exp" => (DateTime.utc_now() |> DateTime.to_unix()) + hours_to_seconds(email_token_hours_valid)
    }

    Jwt.generate_and_sign!(claims)
  end

  def get_email(token) do
    with {:ok, %{"email" => email, "type" => "email_confirmation"}} <-
           Jwt.verify_and_validate(token) do
      {:ok, email}
    else
      {:error, jwt_error} ->
        IO.puts(jwt_error)
        Result.error!(:invalid_confirmation_token, "Invalid Confirmation Token")
    end
  end
end
