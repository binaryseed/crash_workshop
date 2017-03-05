defmodule ProblemD do
  @moduledoc """
  ProblemD.
  """

  @doc """
  Start the Agents.
  """
  def start_link() do
    strategy = :one_for_all

    ## Do not change code below

    import Supervisor.Spec, only: [worker: 3]

    children = [worker(Agent, [&alice/0, [name: :alice]], [id: :alice]),
                worker(Agent, [&bob/0, [name: :bob]], [id: :bob])]

    Supervisor.start_link(children, [strategy: strategy, max_restarts: 1])
  end

  def alice() do
    Map.new()
  end

  def bob() do
    ref = make_ref()
    Agent.update(:alice, fn(map) ->
      Map.update(map, :ref, ref, fn(val) -> raise "ref is #{inspect val}" end)
    end)
    ref
  end
end
