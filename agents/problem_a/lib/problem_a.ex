defmodule ProblemA do
  @moduledoc """
  ProblemA.
  """

  @doc """
  Start Agent with map as state.
  """
  def start_link(map) when is_map(map) do
    Agent.start_link(fn() -> map end)
  end

  @doc """
  Fetch a value from the agent.
  """
  def fetch!(agent, key) do
    case Agent.get(agent, Map, :fetch, [key]) do
      {:ok, result} -> result
      :error -> raise KeyError
    end
  end
end
