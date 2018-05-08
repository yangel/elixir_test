defmodule Servy.Bear do

  @moduledoc false

  defstruct id: nil, name: "", type: "", hibernating: false

  def asc_name(l_bear, r_bear) do
    l_bear.name <= r_bear.name
  end
end
