defmodule PooltoolServerWeb.PingController do
  use PooltoolServerWeb, :controller

  def ping(conn, _otps) do
    json(conn, %{ping: :pong})
  end
end
