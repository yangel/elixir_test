defmodule Servy.BearController do

  @moduledoc false

  alias Servy.Wildthings
  alias Servy.Bear
  alias Servy.BearView

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.asc_name/2)
    %{conv | status: 200, resp_body: BearView.index(bears)}
  end

  def show(conv, %{"id" => id}) do
    if bear = Wildthings.bear_by_id(id) do
      %{conv | status: 200, resp_body: BearView.show(bear)}
    else
      %{conv | status: 404, resp_body: "Bear with id #{id} not found"}
    end
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{conv | status: 201, resp_body: "Create a #{type} bear with a name #{name}"}
  end

  def delete(conv, id) do
    %{conv | status: 403, resp_body: "Unable to delete bear with id = #{id}"}
  end

end
