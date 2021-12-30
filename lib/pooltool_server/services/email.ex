defmodule PooltoolServer.Email do
  import Bamboo.Email

  @from "mefgalm@gmail.com"
  @front_end_url Application.fetch_env!(:pooltool_server, :front_end_url)

  @spec confirm_email(String.t(), String.t()) :: Bamboo.Email.t()
  def confirm_email(to, token) do
    new_email(
      to: to,
      from: @from,
      subject: "Welcome to PoolTool! Confirm Your Email",
      html_body: "<div>You're on your way!<div>
      <div>Let's confirm your email address.<div>
      <div>By clicking on the following link, you are confirming your email address.<div>
      <a href='http://localhost:4000/api/auth/confirm-email?token=#{token}'>Confirm email</a>"
    )
  end

  def forgot_password(to, token) do
    new_email(
      to: to,
      from: @from,
      subject: "Forgot password. PoolTool!",
      html_body: "<div>:(<div>
      <a href='#{@front_end_url}reset-password?token=#{token}'>Forgot password</a>"
    )
  end
end
