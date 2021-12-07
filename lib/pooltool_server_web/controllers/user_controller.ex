defmodule PooltoolServerWeb.UserController do
  use PooltoolServerWeb, :controller
  alias PooltoolServer.UserService

  def sign_up(%Plug.Conn{body_params: body_params} = conn, _otps) do
    json(conn, from_result(UserService.sign_up(body_params["email"], body_params["password"])))
  end
end
