defmodule GravurWeb.PageController do
  use GravurWeb, :controller

  def index(conn, _params) do
    user = Gravur.Identity.current_user(conn)
    unless user do
      render(conn, "index.html")
    else
      redirect(conn, to: GravurWeb.Router.Helpers.book_path(GravurWeb.Endpoint, :index))
    end
  end
end
