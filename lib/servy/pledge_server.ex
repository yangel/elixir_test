defmodule Servy.PledgeServer do
  @moduledoc false

  require Logger

  @process_name :pledge_server

  # Client Interface
  def start do
    IO.puts("Starting Pledge Server..")
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, @process_name)
    pid
  end

  def create_pledge(name, amount) do
    send @process_name, {self(), :create_pledge, name, amount}
    receive do {:response, status} -> status end
  end

  def recent_pledges do
    send @process_name, {self(), :recent_pledges}
    receive do {:response, state} -> state end
  end

  def total_pledged do
    send @process_name, {self(), :total_pledged}
    receive do {:response, total} -> total end
  end

  # Server
  def listen_loop(state) do
    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        send sender, {:response, id}
        most_recent_pledges = Enum.take(state, 2)
        new_state = [{name, amount} | most_recent_pledges]
        listen_loop(new_state)
      {sender, :recent_pledges} ->
        send sender, {:response, state}
        listen_loop(state)
      {sender, :total_pledged} ->
#        total = Enum.map(state, fn {_, amount} -> amount end) |> Enum.sum()
        total = state |> Enum.map(&elem(&1, 1)) |> Enum.sum()
        send sender, {:response, total}
        listen_loop(state)
      unexpected ->
        Logger.warn("Received unexpected message: #{inspect unexpected, pretty: true}")
        listen_loop(state)
    end
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
