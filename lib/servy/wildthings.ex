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
end
