defmodule Servy.Wildthings do

  @moduledoc false

  alias Servy.Bear

  def list_bears do
    [
      %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: true},
      %Bear{id: 2, name: "Smokey", type: "Black", hibernating: true},
      %Bear{id: 3, name: "Snow", type: "Grizzly"},
      %Bear{id: 4, name: "Iceman", type: "Panda"},
      %Bear{id: 5, name: "Scarface", type: "Polar"}
    ]
  end

  def bear_by_id(id) when is_integer id do
    list_bears()
    |> Enum.find(fn bear -> bear.id == id end)
  end

  def bear_by_id(id) when is_binary id do
    id |> String.to_integer |> bear_by_id
  end
end
