defmodule Servy.ImageApi do
  @moduledoc false

  def query(image_id) do
    image_id
      |> api_url
      |> HTTPoison.get
      |> handle_response
  end

  defp api_url(id) do
    "https://api.myjson.com/bins/#{URI.encode(id)}"
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    {
      :ok,
      body
        |> Poison.Parser.parse!
        |> get_in(["image", "image_url"])
    }
  end

  defp handle_response({:ok, %{status_code: _code, body: body}}) do
    {
      :error,
      body
        |> Poison.Parser.parse!
        |> get_in(["message"])
    }
  end

  defp handle_response({:eror, %{reason: reason}}) do
    {:error, reason}
  end

end
