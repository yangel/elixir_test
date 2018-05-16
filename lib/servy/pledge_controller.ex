defmodule Servy.PledgeController do
  @moduledoc false

  alias Servy.PledgeServer
  alias Servy.PledgeView

  def create(conv, %{"name" => name, "amount" => amount}) do
    PledgeServer.create_pledge name, String.to_integer(amount)

    %{conv | status: 201, resp_body: "#{name} pledged #{amount}"}
  end

  def index(conv) do
    pledges = PledgeServer.recent_pledges

    %{conv | status: 200, resp_body: inspect pledges}
  end

  def new(conv) do
    %{conv | status: 200, resp_body: PledgeView.create()}
  end

end
