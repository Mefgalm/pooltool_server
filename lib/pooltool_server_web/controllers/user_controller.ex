defmodule PooltoolServerWeb.UserController do
  use PooltoolServerWeb, :controller
  alias PooltoolServer.UserService
  alias PooltoolServer.Jwt

  @spec hours_to_seconds(pos_integer()) :: pos_integer()
  defp hours_to_seconds(h), do: h * 60 * 60

  def sign_up(%Plug.Conn{body_params: body_params} = conn, _otps) do
    json(conn, from_result(UserService.sign_up(body_params["email"], body_params["password"])))
  end

  @spec sing_in_token!(String.t()) :: String.t()
  def sing_in_token!(email) do
    login_token_hours_valid = Application.fetch_env!(:pooltool_server, :login_token_hours_valid)
    claims = %{"email" => email, "exp" => hours_to_seconds(login_token_hours_valid)}
    Jwt.generate_and_sign!(claims)
  end

  def sign_in(%Plug.Conn{body_params: body_params} = conn, _otps) do
    result = UserService.sign_in(body_params["email"], body_params["password"])

    result_with_jwt =
      case result do
        {:ok, user} -> {:ok, %{user: user, token: sing_in_token!(user.email)}}
        e -> e
      end

    json(conn, from_result(result_with_jwt))
  end

  def confirm_email(%Plug.Conn{body_params: body_params} = conn, _otps) do
    json(conn, from_result(UserService.confirm_email(body_params["token"])))
  end
end
