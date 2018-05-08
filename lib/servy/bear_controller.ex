defmodule Servy.BearController do

  @moduledoc false

  alias Servy.Wildthings

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(fn l_bear, r_bear -> l_bear.name <= r_bear.name end)
      |> Enum.map(fn bear -> "\t<li>#{bear.name} -> #{bear.type}</li>\n" end)
      |> Enum.join

    %{conv | status: 200, resp_body: "<ul>\n#{bears}</ul>"}
  end

  def show(conv, %{"id" => id}) do
    %{conv | status: 200, resp_body: "Bear with id = #{id}"}
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{conv | status: 201, resp_body: "Create a #{type} bear with a name #{name}"}
  end

end