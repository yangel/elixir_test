defmodule Servy.SensorServer do
  @moduledoc false

  alias Servy.Tracker
  alias Servy.VideoCam

  @name :sensor_server

  use GenServer

  defmodule State do
    defstruct [sensor_data: %{}, refresh_interval: :timer.seconds(5)]
  end

  # Client Interface

  def get_sensor_data do
    GenServer.call(@name, :get_sensor_data)
  end

  def set_refresh_interval(refresh_interval) do
    GenServer.cast(@name, {:set_refresh_interval, refresh_interval})
  end

  def start do
    GenServer.start(__MODULE__, %State{}, name: @name)
  end

  def stop() do
    GenServer.stop(@name)
  end

  # Server Callbacks

  def start_link(state, opts) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(state) do
    schedule_new_cache_refreshing(state)
    {:ok, %{state | sensor_data: run_tasks_to_get_sensor_data()}}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast({:set_refresh_interval, refresh_interval}, state) do
    {:noreply, %{state | refresh_interval: refresh_interval}}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  def handle_info(:refresh, state) do
    IO.inspect("Refreshing the cache!")
    schedule_new_cache_refreshing(state)
    {:noreply, %{state | sensor_data: run_tasks_to_get_sensor_data()}}
  end

  defp run_tasks_to_get_sensor_data() do
    task = Task.async(fn -> Tracker.get_location "bigfoot" end)

    snapshots =
      [rand_string(), rand_string(), rand_string()]
      |> Enum.map(&Task.async(fn -> VideoCam.snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    location = Task.await(task)

    %{snapshots: snapshots, locataion: location}
  end

  defp rand_string() do
    ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9)
    |> Enum.take_random(5)
    |> Enum.join()
  end

  defp schedule_new_cache_refreshing(state) do
    Process.send_after(self(), :refresh, state.refresh_interval)
  end
end
