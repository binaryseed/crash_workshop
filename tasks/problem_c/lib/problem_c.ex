defmodule ProblemC do
  @moduledoc """
  ProblemC.
  """

  @doc """
  Run an anonymous function in a separate process.

  Returns `{:ok, result} if the function runs successfully, otherwise
  `{:error, exception}` if an exception is raised.
  """
  def run(fun) do
    fn ->
      try do
        {:ok, fun.()}
      rescue
        error -> {:error, error}
      end
    end
    |> Task.async()
    |> Task.await(:infinity)
  end
end
