defmodule CheckInnWeb.PageController do
  use CheckInnWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
