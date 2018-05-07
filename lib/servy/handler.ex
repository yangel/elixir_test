require Logger

defmodule Servy.Handler do

  @moduledoc "Hndles http requests."

  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.Plugins, only: [emojify: 1, track: 1, rewrite_path: 1, log: 1]
  import Servy.Parser

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

  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%{ method: "GET", path: "/bears" } = conv) do
    %{ conv | status: 200, resp_body: "Teddy" }
  end

  def route(%{ method: "GET", path: "/bears/new" } = conv) do
    show_static_page "create_bear", conv
  end

  def route(%{ method: "GET", path: "/bears/" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Bear with id = #{id}" }
  end

  def route(%{ method: "GET", path: "/about" } = conv) do
    show_static_page "about", conv

#    case File.read(Path.expand("pages") |> Path.join("about.html")) do
#      {:ok, content} -> %{conv | status: 200, resp_body: content}
#      {:error, :enoent} -> %{conv | status: 404, resp_body: "File Not Found!"}
#      {:error, reason} -> %{conv | status: 500, resp_body: "File reading error: #{reason}"}
#    end
  end

  def route(%{ method: "DELETE", path: "/bears/" <> id } = conv) do
    %{ conv | status: 401, resp_body: "Unable to delete bear with id = #{id}" }
  end

  def route(%{method: "GET", path: "/pages/" <> page_name} = conv) do
    show_static_page page_name, conv
  end

  def route(%{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!" }
  end

  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "File Not Found!"}
  end

  def handle_file({:error, reason}, conv) do
    Logger.error "Internal Server Error: #{reason}"
    %{conv | status: 500, resp_body: "File reading error: #{reason}"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason conv.status}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp show_static_page(page_name, conv) do
    @pages_path
    |> Path.join(page_name <> ".html")
    |> File.read
    |> handle_file(conv)
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unathorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
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
