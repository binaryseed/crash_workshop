defmodule ProblemL do
  @moduledoc """
  ProblemL.
  """

  @enforce_keys [:pid, :ref]
  defstruct [:pid, :ref]

  @doc """
  Start a supervising process for tasks to run with async/2.

  The only supported option is [shutdown: timeout | :brutal_kill], where
  `timeout` will try to shutdown the tasks for the timeout and then kill, and
  `:brutal_kill` will kill the tasks straight away when terminating the
  supervisor.
  """

  def start_link(opts \\ []) do
    child_spec = [Supervisor.Spec.worker(__MODULE__, [], opts ++ [function: :task, restart: :temporary])]
    Supervisor.start_link(child_spec, strategy: :simple_one_for_one)
  end

  @doc """
  Start a task under a supervisor and await on the result, as `Task.async`.
  """
  def async(sup, fun) do
    {:ok, pid} = Supervisor.start_child(sup, [fun])
    Process.link(pid)
    ref = Process.monitor(pid)
    send(pid, {:run, self(), ref})
    %ProblemL{pid: pid, ref: ref}
  end

  @doc """
  Await the result of a task, as `Task.await`
  """
  def await(%{ref: ref}=task, timeout) do
    receive do
      {:EXIT, _from, reason} ->
        exit {reason, {__MODULE__, :await, [task, timeout]}}
      {^ref, res} ->
        Process.demonitor(ref, [:flush])
        res
    after
      timeout ->
        Process.demonitor(ref, [:flush])
        exit {:timeout, {__MODULE__, :await, [task, timeout]}}
    end
  end

  def task(fun) do
    {:ok, spawn_link(fn ->
      receive do
        {:run, to, ref} ->
          send(to, {ref, fun.()})
      end
    end)}
  end
end
