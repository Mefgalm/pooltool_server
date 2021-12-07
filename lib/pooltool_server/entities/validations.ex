defmodule PooltoolServer.Validations do
  import Ecto.Changeset

  def validate_email(changeset, field) do
    validate_change(changeset, field, fn _, email ->
      if String.match?(email, ~r/^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$/) do
        []
      else
        [{field, "Email is invalid. Should be like sample@mail.com"}]
      end
    end)
  end
end
