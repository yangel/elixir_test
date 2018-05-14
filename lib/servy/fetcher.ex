defmodule Servy.Fetcher do
  @moduledoc false

  def async(camera_name) do
    parent = self()
    spawn(fn -> send(parent, {:result, Servy.VideoCam.snapshot(camera_name)}) end)
  end

  def get_result do
    receive do {:result, filename} -> filename end
  end

end
