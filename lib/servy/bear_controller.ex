defmodule Servy.BearController do

  @moduledoc false

  alias Servy.Wildthings

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(fn l_bear, r_bear -> l_bear.name <= r_bear.name end)
      |> Enum.map(fn bear -> bear_item bear end)
      |> Enum.join

    %{conv | status: 200, resp_body: "<ul>\n#{bears}</ul>"}
  end

  def show(conv, %{"id" => id}) do
    if bear = Wildthings.bear_by_id(id) do
      %{conv | status: 200, resp_body: "Bear with id = #{bear.id}. Name: #{bear.name}"}
    else
      %{conv | status: 404, resp_body: "Bear with id #{id} not found"}
    end
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{conv | status: 201, resp_body: "Create a #{type} bear with a name #{name}"}
  end

  defp bear_item(bear) do
    "\t<li>#{bear.name} -> #{bear.type}</li>\n"
  end

end