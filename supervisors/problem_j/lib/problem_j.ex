defmodule ProblemJ do
  @moduledoc """
  ProblemJ.
  """

  alias __MODULE__.{Alice, Bob, Carol}

  @doc """
  Start the GenServers.
  """
  def start_link() do
    strategy = :one_for_all

    ## Do not change code below

    import Supervisor.Spec, only: [worker: 2]

    children = [worker(Alice, []), worker(Bob, []), worker(Carol, [])]

    Supervisor.start_link(children, [strategy: strategy, max_restarts: 1])
  end

  defmodule Alice do
    @moduledoc false

    use GenServer
    alias ProblemJ.Carol

    def start_link() do
      GenServer.start_link(__MODULE__, nil, [name: __MODULE__])
    end

    def call_carol(), do: GenServer.call(__MODULE__, :call_carol)

    def init(_) do
      {:ok, nil}
    end

    def handle_call(:call_carol, from, _) do
      GenServer.reply(from, :ok)
      {:noreply, Carol.call_bob()}
    end
  end

  defmodule Bob do
    @moduledoc false

    use GenServer
    alias ProblemJ.Alice

    def start_link() do
      GenServer.start_link(__MODULE__, nil, [name: __MODULE__])
    end

    def call_alice(), do: GenServer.call(__MODULE__, :call_alice)

    def init(_) do
      {:ok, nil}
    end

    def handle_call(:call_alice, from, _) do
      GenServer.reply(from, :ok)
      {:noreply, Alice.call_carol()}
    end
  end

  defmodule Carol do
    @moduledoc false

    use GenServer
    alias ProblemJ.Bob

    def start_link() do
      GenServer.start_link(__MODULE__, nil, [name: __MODULE__])
    end

    def call_bob(), do: GenServer.call(__MODULE__, :call_bob)

    def init(_) do
      Bob.call_alice()
      {:ok, 1}
    end

    def handle_call(:call_bob, _, counter) do
      {:reply, Bob.call_alice(), counter+1}
    end
  end
end
