defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer

  require Logger

  test "accepts a request on a socket and sends back a response" do
    spawn(HttpServer, :start, [4001])

    parent = self()

    max_concurrent_requests = 5

    for _ <- 1..max_concurrent_requests do
      spawn(fn ->
        {:ok, response} = HTTPoison.get "http://localhost:4001/wildthings"
        send(parent, {:ok, response})
      end)
    end

    for _ <- 1..max_concurrent_requests do
      receive do
        {:ok, response} ->
          assert response.status_code == 200
          assert response.body == "Bears, Lions, Tigers"
      end
    end

    spawn(fn ->
      {:ok, response} = HTTPoison.get "http://localhost:4001/bears/some_string"
      send(parent, {:ok, response})
    end)

    receive do
      {:ok, response} -> assert response.status_code == 404
    end
  end
end
