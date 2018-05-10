defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer

  require Logger

  test "accepts a request on a socket and sends back a response" do
    spawn(HttpServer, :start, [4001])

    {:ok, response} = HTTPoison.get "http://localhost:4001/wildthings"

    assert response.status_code == 200
    assert response.body == "Bears, Lions, Tigers"

    {:ok, response} = HTTPoison.get "http://localhost:4001/bears/some_string"
    assert response.status_code == 404
  end
end
