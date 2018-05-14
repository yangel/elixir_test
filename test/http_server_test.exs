defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer

  test "accepts a request on a socket and sends back a response" do
    spawn(HttpServer, :start, [4001])

    ["wildthings", "bears", "about", "api/bears", "bears/1"]
      |> Enum.map(&Task.async(fn -> HTTPoison.get("http://localhost:4001/#{&1}") end))
      |> Enum.map(&Task.await/1)
      |> Enum.map(&assert_success_response/1)

    fn -> HTTPoison.get "http://localhost:4001/bears/some_string" end
      |> Task.async
      |> Task.await
      |> assert_undefined_response
  end

  defp assert_undefined_response({:ok, response}) do
    assert response.status_code == 404
    assert response.body == "Bear with id some_string not found"
  end

  defp assert_success_response({:ok, response}) do
    assert response.status_code == 200
  end
end
