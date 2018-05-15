defmodule PledgeServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  test "caches the 3 most recent pledges and totals their amounts" do
    PledgeServer.start()

    PledgeServer.create_pledge("test1", 10)
    PledgeServer.create_pledge("test2", 20)
    PledgeServer.create_pledge("test3", 30)
    PledgeServer.create_pledge("test4", 40)
    PledgeServer.create_pledge("test5", 50)

    assert PledgeServer.total_pledged() == 120
    assert [{"test5", 50}, {"test4", 40}, {"test3", 30}] == PledgeServer.recent_pledges()

    Process.unregister(:pledge_server)
  end
end
