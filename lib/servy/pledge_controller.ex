defmodule Servy.PledgeController do
  @moduledoc false

  require Logger

  alias Servy.PledgeServer
  alias Servy.PledgeView

  def create(conv, %{"name" => name, "amount" => amount}) do
    PledgeServer.create_pledge name, String.to_integer(amount)

    %{conv | status: 201, resp_body: "#{name} pledged #{amount} <a href='/pledges'>ok</a>"}
  end

  def index(conv) do
    pledges = PledgeServer.recent_pledges

    %{conv | status: 200, resp_body: PledgeView.view(pledges)}
  end

  def new(conv) do
    %{conv | status: 200, resp_body: PledgeView.create()}
  end

end
