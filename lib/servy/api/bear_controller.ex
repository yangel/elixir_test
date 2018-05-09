defmodule Servy.Api.BearController do
  @moduledoc false

  alias Servy.Wildthings

  def index(conv) do
    json = Wildthings.list_bears() |> Poison.encode!
    %{conv | status: 200, resp_body: json, resp_content_type: "application/json"}
  end

end
