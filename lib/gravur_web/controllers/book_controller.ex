defmodule GravurWeb.BookController do
  use GravurWeb, :controller

  plug GravurWeb.Authorize
  plug :put_layout, false when action in [:show]

  def index(conn, _params) do
    user_id = Gravur.Identity.current_user_id(conn)
    books = Gravur.Core.get_all_books(user_id)

    if length(books) != 0 do
      render(conn, "index.html", books: books, user_id: user_id)
    else
      redirect(conn, to: GravurWeb.Router.Helpers.book_path(GravurWeb.Endpoint, :new))
    end
  end

  def new(conn, _params) do
    templates = Gravur.Core.get_templates()

    has_book =
      conn
      |> Gravur.Identity.current_user_id()
      |> Gravur.Core.has_book()

    render(conn, "new.html", changeset: conn, templates: templates, has_book: has_book)
  end

  def create(conn, %{"book" => book_params}) do
    user_id = Gravur.Identity.current_user_id(conn)
    book_params = Map.put(book_params, "user_id", user_id)

    case Gravur.Core.create_book(book_params) do
      {:ok, _} ->
        redirect(conn, to: GravurWeb.Router.Helpers.book_path(GravurWeb.Endpoint, :index))

      {:error, changeset} ->
        templates = Gravur.Core.get_templates()
        render(conn, "new.html", changeset: changeset, templates: templates)
    end
  end

  def delete(conn, %{"id" => book_id}) do
    Gravur.Core.delete_book(book_id)
    redirect(conn, to: GravurWeb.Router.Helpers.book_path(GravurWeb.Endpoint, :index))
  end

  def edit(conn, %{"id" => book_id}) do
    book = Gravur.Core.get_book_with_greetings(book_id)
    render(conn, "edit.html", book: book)
  end

  def update(conn, book_params) do
    case Gravur.Core.update_book(book_params) do
      {:ok, _} ->
        json(conn, %{success: true})

      {:error, _changeset} ->
        json(conn, %{success: false})
    end
  end

  def show(conn, %{"id" => book_id}) do
    book = Gravur.Core.get_book_with_greetings(book_id)
    render(conn, "show.html", greetings: book.greetings)
  end
end
