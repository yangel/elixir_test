defmodule Servy.Api.BearController do
  @moduledoc false

  alias Servy.Wildthings

  def index(conv) do
    json = Wildthings.list_bears() |> Poison.encode!
    %{conv | status: 200, resp_body: json, resp_content_type: "application/json"}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end

end
