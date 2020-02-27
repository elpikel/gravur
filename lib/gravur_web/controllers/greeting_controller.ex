defmodule GravurWeb.GreetingController do
  use GravurWeb, :controller

  plug :put_layout, "mobile.html"

  def index(conn, params) do
    book = Gravur.Core.get_book_with_greetings(params["book_id"])
    render(conn, "index.html", book: book)
  end

  def new(conn, params) do
    book = Gravur.Core.get_book(params["book_id"])
    render(conn, "new.html", changeset: conn, book: book)
  end

  def create(conn, %{"greeting" => greeting_params, "book_id" => book_id}) do
    book = Gravur.Core.get_book(book_id)
    greeting_params = Map.put(greeting_params, "book_id", book_id)

    case Gravur.Core.create_greeting(greeting_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Twój wpis został dodany do księgi.")
        |> redirect(
          to: GravurWeb.Router.Helpers.book_greeting_path(GravurWeb.Endpoint, :index, book)
        )

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Coś poszło nie tak, spróbuj dodać swój wpis ponownie!")
        |> render("new.html", changeset: changeset)
    end
  end
end
