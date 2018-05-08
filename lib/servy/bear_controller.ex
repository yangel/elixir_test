defmodule Servy.BearController do

  def index(conv) do
    %{conv | status: 200, resp_body: "Teddy"}
  end

  def show(conv, %{"id" => id}) do
    %{conv | status: 200, resp_body: "Bear with id = #{id}"}
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    %{conv | status: 201, resp_body: "Create a #{type} bear with a name #{name}"}
  end

end