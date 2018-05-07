require Logger

defmodule Servy.Plugins do
  def emojify(%{ status: 200 } = conv) do
    e = String.duplicate("🎉", 10)
    %{ conv | resp_body: e <> "\n" <> conv.resp_body <> "\n" <> e }
  end

  def emojify(conv), do: conv

  def track(%{ status: 404, path: path } = conv) do
    Logger.warn fn -> "Unable to find route #{path}" end
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{ path: "/wildlife" } = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(%{ path: "/bears?id=" <> id } = conv) do
    %{ conv | path: "/bears/#{id}" }
  end

  def rewrite_path(conv), do: conv

  def log(data), do: IO.inspect(data)
end