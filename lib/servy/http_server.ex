defmodule Servy.HttpServer do

  require Logger

  alias Servy.Handler

  def start(port) when is_integer(port) and port > 1023 do
    {:ok, listen_socket} = :gen_tcp.listen(
      port,
      [:binary, packet: :raw, active: false, reuseaddr: true]
    )

    Logger.info("\n\nListening for connection request on port #{port}...\n\n")

    accept_loop listen_socket
  end

  defp accept_loop(listen_socket) do
    Logger.info("Waiting to accept a client connection...\n")

    {:ok, client_socket} = :gen_tcp.accept(listen_socket)

    Logger.info("Connection accepted!\n")

    serve client_socket
    accept_loop listen_socket
  end

  defp serve(client_socket) do
    client_socket
    |> read_request
    |> Handler.handle
    |> write_response(client_socket)
  end

  defp read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)

    Logger.info("Received request:\n")
    Logger.info(request)

    request
  end

  defp write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)

    Logger.info("Sending response:\n")
    Logger.info(response)

    :gen_tcp.close(client_socket)
  end
end
