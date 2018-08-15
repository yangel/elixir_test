defmodule Servy.FourOhFourCounter do
  @moduledoc false

  @service_name __MODULE__

  use GenServer

  # Client
  def start do
    GenServer.start(__MODULE__, %{}, name: @service_name)
  end

  def stop do
    GenServer.stop(@service_name)
  end

  def process_name do
    @service_name
  end

  def bump_count(path) do
    GenServer.call @service_name, {:bump_count, path}
  end

  def get_count(path) do
    GenServer.call @service_name, {:get_count, path}
  end

  def get_counts do
    GenServer.call @service_name, :get_counts
  end

  def clear do
    GenServer.cast @service_name, :clear
  end

  def handle_call(:get_counts, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:bump_count, path}, _from, state) do
    new_state = Map.update(state, path, 1, &(&1 + 1))
    {:reply, :ok, new_state}
  end

  def handle_call({:get_count, path}, _from, state) do
    {:reply, Map.get(state, path, 0), state}
  end

  def handle_cast(:clear, _state) do
    {:no_reply, %{}}
  end

end
