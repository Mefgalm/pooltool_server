defmodule PooltoolServer.Jwt do
  use Joken.Config

  @impl true
  def token_config do
    default_claims(iss: "PooltoolServer", aud: "PooltoolServer")
  end
end
