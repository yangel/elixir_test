defmodule Servy do

  @moduledoc "Main module"

  def hello(name) do
    "Hello, #{name}"
  end
end

IO.puts Servy.hello("Test!")
