defmodule Servy.PledgeServer do
  @moduledoc false

  require Logger

  @process_name :pledge_server

  # Client Interface
  def start(initial_state \\ []) do
    IO.puts("Starting Pledge Server..")
    pid = spawn(__MODULE__, :listen_loop, [initial_state])
    Process.register(pid, @process_name)
    pid
  end

  def create_pledge(name, amount) do
    call @process_name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    call @process_name, :recent_pledges
  end

  def total_pledged do
    call @process_name, :total_pledged
  end

  def call(pid, message) do
    send pid, {self(), message}
    receive do {:response, response} -> response end
  end

  # Server
  def listen_loop(state) do
    receive do
      {sender, message} when is_pid(sender) ->
        {response, new_state} = handle_call(message, state)
        send sender, {:response, response}
        listen_loop new_state
      unexpected ->
        Logger.warn("Received unexpected message: #{inspect unexpected, pretty: true}")
        listen_loop(state)
    end
  end

  def handle_call(:total_pledged, state) do
#   total = Enum.map(state, fn {_, amount} -> amount end) |> Enum.sum()
    {state |> Enum.map(&elem(&1, 1)) |> Enum.sum(), state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [{name, amount} | most_recent_pledges]
    {id, new_state}
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, random_id 50}
  end

  defp random_id(length) do
    length
      |> :crypto.strong_rand_bytes()
      |> Base.url_encode64()
      |> binary_part(0, length)
      |> String.downcase()
  end

end
