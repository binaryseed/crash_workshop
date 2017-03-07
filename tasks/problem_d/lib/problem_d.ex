defmodule ProblemD do
  @moduledoc """
  ProblemD.
  """

  @enforce_keys [:pid, :ref]
  defstruct [:pid, :ref]

  @doc """
  Start a task and await on the result, as `Task.async`.
  """
  def async(fun) do
    pid = spawn_link(fn ->
            receive do
              {:async, to, ref} ->
                send(to, {ref, fun.()})
            end
          end)
    ref = Process.monitor(pid)
    send(pid, {:async, self(), ref})
    %ProblemD{pid: pid, ref: ref}
  end

  @doc """
  Await the result of a task, as `Task.await`
  """
  def await(%{ref: ref}=task, timeout) do
    receive do
      {:DOWN, ^ref, _, _, reason} ->
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

  @doc """
  Yield to wait the result of a task, as `Task.yield`.
  """
  def yield(%{ref: ref}, timeout) do
    receive do
      {:DOWN, ^ref, _, _, reason} ->
        {:exit, reason}
      {^ref, res} ->
        Process.demonitor(ref, [:flush])
        {:ok, res}
    after
      timeout ->
        nil
    end
  end
end
