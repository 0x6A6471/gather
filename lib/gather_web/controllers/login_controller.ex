defmodule GatherWeb.LoginController do
  use GatherWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
