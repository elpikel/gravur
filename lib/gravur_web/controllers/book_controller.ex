defmodule GravurWeb.BookController do
  use GravurWeb, :controller

  plug GravurWeb.Authorize

  def index(conn, _params) do
    books = conn
      |> Gravur.Identity.current_user_id()
      |> Gravur.Core.get_all_books()

    if length(books) != 0 do
      render(conn, "index.html", books: books)
    else
      redirect(conn, to: GravurWeb.Router.Helpers.book_path(GravurWeb.Endpoint, :new))
    end
  end

  def new(conn, _params) do
    templates = Gravur.Core.get_templates()
    has_book = conn
      |> Gravur.Identity.current_user_id()
      |> Gravur.Core.has_book()

    render(conn, "new.html", changeset: conn, templates: templates, has_book: has_book)
  end

  def create(conn, %{"book" => book_params}) do
    user_id = Gravur.Identity.current_user_id(conn)
    book_params = Map.put(book_params, "user_id", user_id)

    case Gravur.Core.create_book(book_params) do
      {:ok, _} ->
        conn
        |> redirect(to: GravurWeb.Router.Helpers.book_path(GravurWeb.Endpoint, :index))
      {:error, changeset} ->
        templates = Gravur.Core.get_templates()
        render(conn, "new.html", changeset: changeset, templates: templates)
    end
  end
end
