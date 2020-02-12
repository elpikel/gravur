defmodule GravurWeb.PageController do
  use GravurWeb, :controller

  plug :put_layout, "landing.html"

  def index(conn, _params) do
    if Gravur.Identity.user_signed_in?(conn) do
      redirect(conn, to: GravurWeb.Router.Helpers.book_path(GravurWeb.Endpoint, :index))
    else
      render(conn, "index.html")
    end
  end
end
