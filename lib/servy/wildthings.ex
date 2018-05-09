defmodule Servy.Wildthings do

  @moduledoc false

  alias Servy.Bear

  def list_bears do
    Path.expand("../../db", __DIR__)
    |> Path.join("bears.json")
    |> read_json
    |> Poison.decode!(as: %{"bears" => [%Bear{}]})
    |> Map.get("bears")
  end

  def bear_by_id(id) when is_integer id do
    list_bears()
    |> Enum.find(fn bear -> bear.id == id end)
  end

  def bear_by_id(id) when is_binary id do
    id |> String.to_integer |> bear_by_id
  end

  defp read_json(source) do
    case File.read source do
      {:ok, content} -> content
      {:error, reason} ->
        require Logger
        Logger.error("Unable to read json file: #{inspect reason}")
        "[]"
    end
  end
end
