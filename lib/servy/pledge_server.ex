defmodule Servy.PledgeServer do
  @moduledoc false

  @process_name :pledge_server

  use GenServer

  # Client Interface
  def start(initial_state \\ []) do
    GenServer.start(__MODULE__, initial_state, name: @process_name)
  end

  def create_pledge(name, amount) do
    GenServer.call @process_name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenServer.call @process_name, :recent_pledges
  end

  def total_pledged do
    GenServer.call @process_name, :total_pledged
  end

  def clear do
    GenServer.cast @process_name, :clear
  end

  def handle_cast(:clear, _state) do
    {:noreply, []}
  end

  def handle_call(:total_pledged, _from, state) do
#   total = Enum.map(state, fn {_, amount} -> amount end) |> Enum.sum()
    {:reply, state |> Enum.map(&elem(&1, 1)) |> Enum.sum(), state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [{name, amount} | most_recent_pledges]
    {:reply, id, new_state}
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
