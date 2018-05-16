defmodule Servy.PledgeView do
  @moduledoc false

  require EEx

  @templates_path Path.expand("../../templates", __DIR__)

  EEx.function_from_file :def, :create, Path.join(@templates_path, "new_pledge.html.eex")
end
