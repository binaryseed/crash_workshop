defmodule ProblemC.Application do
  @moduledoc false

  alias ProblemC.{Tracker, ServerSupervisor, Starter}

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [worker(ServerSupervisor, []), worker(Tracker, []), worker(Starter, [])]
    Supervisor.start_link(children, [strategy: :one_for_all])
  end
end
