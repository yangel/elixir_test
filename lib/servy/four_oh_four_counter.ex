defmodule Servy.FourOhFourCounter do
  @moduledoc false

  @service_name __MODULE__

  alias Servy.GenericServer

  # Client
  def start do
    GenericServer.start(__MODULE__, %{}, @service_name)
  end

  def stop do
    GenericServer.stop(@service_name)
  end

  def process_name do
    @service_name
  end

  def bump_count(path) do
    GenericServer.call @service_name, {:bump_count, path}
  end

  def get_count(path) do
    GenericServer.call @service_name, {:get_count, path}
  end

  def get_counts do
    GenericServer.call @service_name, :get_counts
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end

  def handle_call({:bump_count, path}, state) do
    new_state = Map.update(state, path, 1, fn count -> count + 1 end)
    {:ok, new_state}
  end

  def handle_call({:get_count, path}, state) do
    count = Map.get(state, path)
    {count, state}
  end

end
