defmodule GravurWeb.BookController do
  use GravurWeb, :controller

  def index(conn, _params) do
    user = Gravur.Identity.current_user(conn)
    unless user do
      conn
      |> send_resp(401, "unauthorized") # move to plug
      |> halt()
    else
      books = Gravur.Core.get_all_books(user.id)
      render(conn, "index.html", books: books)
    end
  end

  def new(conn, _params) do
    templates = Gravur.Core.get_templates()
    render(conn, "new.html", changeset: conn, templates: templates)
  end

  def create(conn, %{"book" => book_params}) do
    user = Gravur.Identity.current_user(conn)
    book_params = Map.put(book_params, "user_id", user.id)

    case Gravur.Core.create_book(book_params) do
      {:ok, _} ->
        conn
        |> redirect(to: GravurWeb.Router.Helpers.book_path(GravurWeb.Endpoint, :index))

      {:error, changeset} ->
      render(conn, "new.html", changeset: changeset)
    end
  end
end
