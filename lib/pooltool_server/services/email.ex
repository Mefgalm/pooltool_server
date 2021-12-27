defmodule PooltoolServer.Email do
  import Bamboo.Email

  @spec confirm_email(String.t(), String.t()) :: Bamboo.Email.t()
  def confirm_email(to, token) do
    new_email(
      to: to,
      from: "mefgalm@gmail.com",
      subject: "Welcome to PoolTool! Confirm Your Email",
      html_body: "<div>You're on your way!<div>
      <div>Let's confirm your email address.<div>
      <div>By clicking on the following link, you are confirming your email address.<div>
      <a href='http://localhost:3000/confirm-password?token=#{token}'>Confirm email</a>"
    )
  end
end
