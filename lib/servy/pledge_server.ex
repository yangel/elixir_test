defmodule Servy.GenericServer do
  @moduledoc false

  require Logger

  def start(initial_state \\ [], name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state])
    Process.register(pid, name)
    pid
  end

  def call(pid, message) do
    send pid, {:call, self(), message}
    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send pid, {:cast, message}
  end

  # Server
  def listen_loop(state) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = Servy.PledgeServer.handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state)
      {:cast, message} ->
        new_state = Servy.PledgeServer.handle_cast(message, state)
        listen_loop(new_state)
      unexpected ->
        Logger.warn("Received unexpected message: #{inspect unexpected, pretty: true}")
        listen_loop(state)
    end
  end
end

defmodule Servy.PledgeServer do
  @moduledoc false

  alias Servy.GenericServer

  @process_name :pledge_server

  # Client Interface
  def start(initial_state \\ []) do
    Servy.GenericServer.start(initial_state, @process_name)
  end

  def create_pledge(name, amount) do
    GenericServer.call @process_name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenericServer.call @process_name, :recent_pledges
  end

  def total_pledged do
    GenericServer.call @process_name, :total_pledged
  end

  def clear do
    GenericServer.cast @process_name, :clear
  end

  def handle_cast(:clear, _state) do
    []
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
