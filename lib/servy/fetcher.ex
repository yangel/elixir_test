defmodule Servy.Fetcher do
  @moduledoc false

  def async(function) do
    parent = self()
    spawn(fn -> send(parent, {:result, function.()}) end)
  end

  def get_result do
    receive do {:result, value} -> value end
  end

end
