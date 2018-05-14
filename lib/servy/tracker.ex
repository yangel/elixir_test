defmodule Servy.Tracker do
  @moduledoc false

  @doc """
  Simulates sending a request to an external API
  to get the GPS coordinates of a wildthing.
  """
  def get_location(wildthing) do
    :timer.sleep(500)

    locations = %{
      "roscoe" => %{lat: "44.42354 N", lng: "110.5885 W"},
      "smokey" => %{lat: "45.42354 N", lng: "110.5885 W"},
      "brutus" => %{lat: "46.42354 N", lng: "110.5885 W"},
      "bigfoot" => %{lat: "47.42354 N", lng: "110.5885 W"}
    }

    Map.get(locations, wildthing)
  end
end
