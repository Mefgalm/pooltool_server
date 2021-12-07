defmodule PooltoolServer.Repo do
  use Ecto.Repo,
    otp_app: :pooltool_server,
    adapter: Ecto.Adapters.Postgres
end
