defmodule Result do
  @errors ~w(validation invalid_email_or_password)a

  @type error:: {:error, atom, String.t()}

  @spec error!(atom, String.t()) :: error
  def error!(code, message) do
    case Enum.find(@errors, &(&1 == code)) do
      nil -> raise "Error code '#{code}' not found"
      code -> {:error, code, message}
    end
  end


end
