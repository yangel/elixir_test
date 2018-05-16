defmodule Servy.PledgeView do
  @moduledoc false

  require EEx

  @templates_path Path.expand("../../templates", __DIR__)

  EEx.function_from_file :def, :create, Path.join(@templates_path, "new_pledge.html.eex")

  EEx.function_from_file :def, :view, Path.join(@templates_path, "view_pledges.html.eex"), [:pledges]
end
