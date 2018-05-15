defmodule Servy.FourOhFourCounter do
  @moduledoc false

  @service_name __MODULE__

  # Client
  def start do
    pid = spawn(__MODULE__, :listen_loop, [%{}])
    Process.register(pid, @service_name)
  end

  def bump_count(path) do
    send @service_name, {self(), :bump_count, path}
    receive do {:response, state} -> state end
  end

  def get_count(path) do
    send @service_name, {self(), :get_count, path}
    receive do {:response, count} -> count end
  end

  def get_counts do
    send @service_name, {self(), :get_counts}
    receive do {:response, map} -> map end
  end

  def stop do
    Process.unregister(@service_name)
  end

  def process_name do
    @service_name
  end

  # Server
  def listen_loop(state) do
    require Logger

    if Mix.env == :test do
      Logger.debug(inspect state, pretty: true)
    end

    receive do
      {sender, :bump_count, path} ->
        new_state = Map.update(state, path, 1, fn count -> count + 1 end)
        send sender, {:response, :ok}
        listen_loop(new_state)
      {sender, :get_counts} ->
        send sender, {:response, state}
        listen_loop(state)
      {sender, :get_count, path} ->
        count = Map.get(state, path)
        send sender, {:response, count}
        listen_loop(state)
      unexpected ->
        Logger.warn("Unexpected message: #{inspect unexpected, pretty: true}")
        listen_loop(state)
    end
  end

end
