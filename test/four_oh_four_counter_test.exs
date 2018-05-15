defmodule FourOhFourCounterTest do
  use ExUnit.Case

  alias Servy.FourOhFourCounter, as: Counter

  test "starts and stops service correctly" do
    assert nil == Process.whereis(Counter.process_name())

    Counter.start()
    assert nil != Process.whereis(Counter.process_name())

    Counter.stop()
    assert nil == Process.whereis(Counter.process_name())
  end

  test "reports counts of missing path requests" do
    Counter.start()

    Counter.bump_count("/bigfoot")
    Counter.bump_count("/nessie")
    Counter.bump_count("/nessie")
    Counter.bump_count("/bigfoot")
    Counter.bump_count("/nessie")

    assert Counter.get_count("/nessie") == 3
    assert Counter.get_count("/bigfoot") == 2

    assert Counter.get_counts == %{"/bigfoot" => 2, "/nessie" => 3}

    Counter.stop()
  end
end
