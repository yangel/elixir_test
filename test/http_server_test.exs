defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer

  test "accepts a request on a socket and sends back a response" do
    spawn(HttpServer, :start, [4001])

    url = "http://localhost:4001/wildthings"
    1..5
      |> Enum.map(fn (_) -> Task.async(fn -> HTTPoison.get url end) end)
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
    assert response.body == "Bears, Lions, Tigers"
  end
end
