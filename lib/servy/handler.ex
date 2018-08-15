require Logger

defmodule Servy.Handler do

  @moduledoc "Handles http requests."

  import Servy.Parser, only: [parse: 1]
  import Servy.Plugins, only: [track: 1, rewrite_path: 1, log: 1]
  import Servy.StaticPages, only: [show_static_page: 2]

  alias Servy.BearController
  alias Servy.Conv
  alias Servy.FourOhFourCounter
  alias Servy.PledgeController
  alias Servy.SensorServer

  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/404/" <> path} = conv) do
    not_found = FourOhFourCounter.get_count(path)
    %{conv | status: 200, resp_body: inspect not_found}
  end

  def route(%Conv{method: "GET", path: "/404"} = conv) do
    all_not_found = FourOhFourCounter.get_counts()
    %{conv | status: 200, resp_body: inspect all_not_found}
  end

  def route(%Conv{method: "GET", path: "/pledges"} = conv) do
    PledgeController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/pledges/new"} = conv) do
    PledgeController.new(conv)
  end

  def route(%Conv{method: "POST", path: "/pledges"} = conv) do
    PledgeController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/crash"} = _conv) do
    raise "Crash!"
  end

  def route(%Conv{method: "GET", path: "/sensors"} = conv) do
    %{conv | status: 200, resp_body: inspect(SensorServer.get_sensor_data())}
  end

  def route(%Conv{method: "GET", path: "/hibernate/" <> time} = conv) do
    time
    |> String.to_integer
    |> :timer.sleep

    %{conv | status: 200, resp_body: "Awake!"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end

  def route(%Conv{method: "POST", path: "/api/bears"} = conv) do
    Servy.Api.BearController.create(conv, conv.params)
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
    content = show_static_page "about", conv
    %{conv | status: 200, resp_body: Earmark.as_html!(content.resp_body)}

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
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{conv.resp_content_type}\r
    Content-Length: #{String.length(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end
