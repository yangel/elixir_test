require Logger

defmodule Servy.Handler do

  @moduledoc "Handles http requests."

  import Servy.Plugins, only: [emojify: 1, track: 1, rewrite_path: 1, log: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.StaticPages, only: [show_static_page: 2]

  alias Servy.Conv, as: Conv
  alias Servy.BearController, as: BearController

  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> emojify
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    show_static_page "create_bear", conv
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    show_static_page "about", conv

#    case File.read(Path.expand("pages") |> Path.join("about.html")) do
#      {:ok, content} -> %{conv | status: 200, resp_body: content}
#      {:error, :enoent} -> %{conv | status: 404, resp_body: "File Not Found!"}
#      {:error, reason} ->
#        %{conv | status: 500, resp_body: "File reading error: #{reason}"}
#    end
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> id} = conv) do
    BearController.delete(conv, id)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> page_name} = conv) do
    show_static_page page_name, conv
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /bears?id=100500 HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
DELETE /bears/2 HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /pages/new HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /pages/faq HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Conent-Length: 22

name=Baloo&type=Brown
"""

IO.puts Servy.Handler.handle(request)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: Browser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)
