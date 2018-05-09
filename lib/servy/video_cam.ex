defmodule Servy.VideoCam do
  @moduledoc false

  def snapshot(file_name) do
    :timer.sleep(1000)

    "#{file_name}-snapshot.jpg"
  end

end
