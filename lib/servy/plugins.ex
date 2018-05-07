require Logger

defmodule Servy.Plugins do

  alias Servy.Conv, as: Conv

  def emojify(%Conv{ status: 200 } = conv) do
    e = String.duplicate("🎉", 10)
    %{ conv | resp_body: e <> "\n" <> conv.resp_body <> "\n" <> e }
  end

  def emojify(%Conv{} = conv), do: conv

  def track(%Conv{ status: 404, path: path } = conv) do
    Logger.warn fn -> "Unable to find route #{path}" end
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{ path: "/wildlife" } = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(%Conv{ path: "/bears?id=" <> id } = conv) do
    %{ conv | path: "/bears/#{id}" }
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(data), do: IO.inspect(data)
end