defmodule Servy do

  @moduledoc "Main module"

  alias Servy.PledgeServer
  alias Servy.HttpServer
  alias Servy.FourOhFourCounter

  def hello(name) do
    "Hello, #{name}"
  end

  def start_engines(port \\ 4000) do
    PledgeServer.start()
    FourOhFourCounter.start()
    spawn(fn -> HttpServer.start port end)
  end
end
