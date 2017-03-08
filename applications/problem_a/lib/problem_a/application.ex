defmodule ProblemA.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      supervisor(ProblemA.Sup, []),
    ]
    Supervisor.start_link(children, [strategy: :one_for_one])
  end
end

defmodule ProblemA.Sup do
  def start_link() do
    import Supervisor.Spec, warn: false
    children = [
      worker(ProblemA.Data, []),
      worker(ProblemA.Alice, []),
      worker(ProblemA.Bob, []),
    ]
    Supervisor.start_link(children, [strategy: :one_for_one, max_restarts: 3])
  end
end
