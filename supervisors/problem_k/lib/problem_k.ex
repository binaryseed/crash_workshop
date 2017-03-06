defmodule ProblemK do
  @moduledoc """
  ProblemK.
  """

  @doc """
  Write a Task supervising process that starts a single task with
  `Task.start_link(fun)` and restarts it if it exits.
  """

  def start_link(fun) do
    Task.start_link(fn ->
      Process.flag(:trap_exit, true)
      init(fun)
    end)
  end

  def init(fun) do
    {:ok, task} = Task.start_link(fun)
    loop(task, fun)
  end

  def loop(task, fun) do
    receive do
      {:EXIT, ^task, :shutdown} ->
        exit(:shutdown)
      {:EXIT, ^task, :crash} ->
        init(fun)
      {:EXIT, _from, :crash} ->
        loop(task, fun)
    end
  end
end
