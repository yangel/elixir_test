defmodule Servy.Fetcher do
  @moduledoc false

  def async(function) do
    parent = self()
    spawn(fn -> send(parent, {self(), :result, function.()}) end)
  end

  def get_result(pid) do
    receive do {^pid, :result, value} -> value end
  end

end
