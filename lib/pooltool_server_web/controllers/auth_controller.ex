defmodule PooltoolServerWeb.AuthController do
  use PooltoolServerWeb, :controller
  alias DateTime.Extensions, as: DateTimeExt
  alias PooltoolServer.UserService
  alias PooltoolServer.Jwt

  def sign_up(%Plug.Conn{body_params: body_params} = conn, _otps) do
    json(conn, from_result(UserService.sign_up(body_params["email"], body_params["password"])))
  end

  def sign_in(%Plug.Conn{body_params: body_params} = conn, _otps) do
    result =
      UserService.sign_in(body_params["email"], body_params["password"])
      |> Result.map(fn user ->
        login_token_hours_valid =
          Application.fetch_env!(:pooltool_server, :login_token_hours_valid)

        claims = %{
          "email" => user.email,
          "exp" => DateTimeExt.add_hours_to_unix(DateTime.utc_now(), login_token_hours_valid)
        }

        %{user: user, token: Jwt.generate_and_sign!(claims)}
      end)

    json(conn, from_result(result))
  end

  def confirm_email(%Plug.Conn{query_params: query_params} = conn, _otps) do
    UserService.confirm_email!(query_params["token"])

    front_end_url = Application.fetch_env!(:pooltool_server, :front_end_url)

    conn
    |> Plug.Conn.resp(301, "")
    |> Plug.Conn.put_resp_header("Location", front_end_url)
  end

  def forgot_password(%Plug.Conn{body_params: body_params} = conn, _otps) do
    json(conn, from_result(UserService.forgot_password(body_params["email"])))
  end

  def reset_password(%Plug.Conn{body_params: body_params} = conn, _otps) do
    result = UserService.reset_password(body_params["newPassword"], body_params["token"])

    json(conn, from_result(result))
  end
end
