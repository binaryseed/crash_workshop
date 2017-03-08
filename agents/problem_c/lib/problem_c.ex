defmodule ProblemC do
  @moduledoc """
  ProblemC.
  """

  @doc """
  Start task.
  """
  def start_link() do
    Task.start_link(__MODULE__, :loop, [])
  end

  @doc """
  Call task.
  """
  def call(task, request, timeout) do
    send(task, {__MODULE__, self(), request})
    receive do
      {__MODULE__, response} ->
        response
      {:EXIT, from, reason} ->
        exit {reason, {__MODULE__, :call, [task, request, timeout]}}
    after
      timeout ->
        exit {:timeout, {__MODULE__, :call, [task, request, timeout]}}
    end
  end

  @doc """
  Reply to call
  """
  def reply(from, response) do
    send(from, {__MODULE__, response})
  end

  @doc false
  def loop() do
    receive do
      {__MODULE__, from, :ping} ->
        __MODULE__.reply(from, :pong)
        loop()
      {__MODULE__, _, :ignore} ->
        loop()
      {__MODULE__, _, :stop} ->
        exit(:stop)
    end
  end
end
