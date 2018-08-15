defmodule Servy.SensorServer do
  @moduledoc false

  alias Servy.Tracker
  alias Servy.VideoCam

  @name :sensor_server

  use GenServer

  # Client Interface

  def get_sensor_data do
    GenServer.call(@name, :get_sensor_data)
  end

  def start do
    GenServer.start(__MODULE__, %{}, name: @name)
  end

  def stop() do
    GenServer.stop(@name)
  end

  # Server Callbacks

  def start_link(state, opts) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(_opts) do
    {:ok, run_tasks_to_get_sensor_data()}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  defp run_tasks_to_get_sensor_data() do
    task = Task.async(fn -> Tracker.get_location "bigfoot" end)

    snapshots =
      ["16x3i5", "16x3i5", "16x3i5"]
      |> Enum.map(&Task.async(fn -> VideoCam.snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    location = Task.await(task)

    %{snapshots: snapshots, locataion: location}
  end
end
