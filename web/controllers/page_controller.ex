defmodule TinderClone.PageController do
  use TinderClone.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
