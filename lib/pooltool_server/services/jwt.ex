defmodule PooltoolServer.Jwt do
  use Joken.Config

  @spec email_confirmation(String.t()) :: String.t()
  def email_confirmation(email) do
    claims = %{"email" => email, "type" => :email_confirmation}
    generate_and_sign!(claims)
  end
end
