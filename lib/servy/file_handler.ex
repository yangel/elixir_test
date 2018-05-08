require Logger

defmodule Servy.FileHandler do

  @moduledoc "Handles files"

  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "File Not Found!"}
  end

  def handle_file({:error, reason}, conv) do
    Logger.error "Internal Server Error: #{reason}"
    %{conv | status: 500, resp_body: "File reading error: #{reason}"}
  end
end