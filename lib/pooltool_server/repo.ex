defmodule PooltoolServer.Repo do
  use Ecto.Repo,
    otp_app: :pooltool_server,
    adapter: Ecto.Adapters.Postgres

  @spec handle_changset_error({:error, Ecto.Changeset.t()} | {:ok, any}) :: Result.t()
  def handle_changset_error({:ok, _} = res), do: res

  def handle_changset_error({:error, changeset}) do
    errors_map =
      Ecto.Changeset.traverse_errors(changeset, fn _x, _f, {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    validation_message =
      errors_map
      |> Map.values()
      |> Enum.join(", ")

    Result.error!(:validation, validation_message)
  end
end
