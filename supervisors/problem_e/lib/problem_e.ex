defmodule ProblemE do
  @moduledoc """
  ProblemE.
  """

  @doc """
  Start a Supervisor for Agents.
  """
  def start_link(opts \\ [restart: :temporary]) do
    children = [Supervisor.Spec.worker(Agent, [], opts)]
    Supervisor.start_link(children, [strategy: :simple_one_for_one] ++ opts)
  end

  @doc """
  Start an Agent with a fun.
  """
  def start_child(sup, fun, opts \\ []) do
    Supervisor.start_child(sup, [fun])
  end

  @doc """
  Start an Agent with module, function and arguments.
  """
  def start_child(sup, mod, fun, args, opts \\ []) do
    Supervisor.start_child(sup, [mod, fun, args])
  end
end
