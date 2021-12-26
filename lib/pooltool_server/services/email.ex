defmodule PooltoolServer.Email do
  import Bamboo.Email

  def welcome_email(to) do
    new_email(
      to: to,
      from: "mefgalm@gmail.com",
      subject: "Welcome to the PoolTool!",
      html_body: "<strong>Pooltool strong!</strong>",
      text_body: "Thanks for joining!"
    )
  end
end
