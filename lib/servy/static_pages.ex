defmodule Servy.StaticPages do

  @moduledoc "Module for loading static pages"

  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.FileHandler, only: [handle_file: 2]

  def show_static_page(page_name, conv) do
    @pages_path
    |> Path.join(page_name <> ".html")
    |> File.read
    |> handle_file(conv)
  end
end