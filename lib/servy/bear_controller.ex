defmodule Servy.BearController do

  @moduledoc false

  alias Servy.Wildthings
  alias Servy.Bear

  @templates_path Path.expand("../../templates", __DIR__)

  defp render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conv | status: 200, resp_body: content}
  end

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.asc_name/2)

    render conv, "index.html.eex", bears: bears
  end

  def show(conv, %{"id" => id}) do
    if bear = Wildthings.bear_by_id(id) do
      render conv, "show.html.eex", bear: bear
    else
      %{conv | status: 404, resp_body: "Bear with id #{id} not found"}
    end
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{conv | status: 201, resp_body: "Create a #{type} bear with a name #{name}"}
  end

  def delete(conv, id) do
    %{conv | status: 401, resp_body: "Unable to delete bear with id = #{id}"}
  end

end
