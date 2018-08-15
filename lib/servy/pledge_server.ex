defmodule Servy.PledgeServer do
  @moduledoc false

  @process_name :pledge_server

  use GenServer

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  # Client Interface
  def start do
    GenServer.start(__MODULE__, %State{}, name: @process_name)
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

  def set_cache_size(size) do
    GenServer.cast @process_name, {:set_cache_size, size}
  end

  # Server Callbacks

  def init(state) do
    pledges_from_service = fetch_recent_pledges_form_service()
    {:ok, %{state | pledges: pledges_from_service}}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    new_state = %{state | cache_size: size}
    {:noreply, new_state}
  end

  def handle_call(:total_pledged, _from, state) do
#   total = Enum.map(state, fn {_, amount} -> amount end) |> Enum.sum()
    {:reply, state.pledges |> Enum.map(&elem(&1, 1)) |> Enum.sum(), state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state.pledges, state.cache_size - 1)
    cached_pledges = [{name, amount} | most_recent_pledges]
    new_state = %{state | pledges: cached_pledges}
    {:reply, id, new_state}
  end

  def handle_info(message, state) do
    IO.puts("Can't touch this. Message: #{inspect(message)}")
    {:noreply, state}
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

  defp fetch_recent_pledges_form_service do
    [{"Evgeny", 15}, {"Fred", 20}]
  end

end
