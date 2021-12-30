defmodule DateTime.Extensions do

  @doc ~S"""
    Add hourse to date and convert to Unix time
    ## Examples
      iex> DateTime.Extensions.add_hours_to_unix(~U[2021-12-29 17:43:44.557682Z], 2)
      1640807024
      iex> DateTime.Extensions.add_hours_to_unix(~U[2021-12-29 17:43:44.557682Z], -2)
      1640792624
      iex> DateTime.Extensions.add_hours_to_unix(~U[2021-12-29 17:43:44.557682Z], 0)
      1640799824
  """
  @spec add_hours_to_unix(DateTime.t(), number()) :: integer()
  def add_hours_to_unix(date, hours),
    do:
      date
      |> DateTime.add(hours * 60 * 60)
      |> DateTime.to_unix()
end
