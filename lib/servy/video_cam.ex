defmodule Servy.VideoCam do
  @moduledoc false

  alias Servy.ImageApi

  def snapshot(file_name) do
    case ImageApi.query(file_name) do
      {:ok, image_url} -> image_url
      {:error, message} -> "Whoops, #{message}"
    end
  end

end
