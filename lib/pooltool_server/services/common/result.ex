defmodule Result do
  @errors ~w(validation invalid_email_or_password invalid_token)a

  @type error :: {:error, atom, String.t()}

  @spec error!(atom, String.t()) :: error
  def error!(code, message) do
    case Enum.find(@errors, &(&1 == code)) do
      nil -> raise "Error code '#{code}' not found"
      code -> {:error, code, message}
    end
  end

  @spec map({:ok, any}, (any -> any)) :: {:ok, any}
  def map({:ok, data}, f), do: {:ok, f.(data)}
  def map(x, _), do: x
end
