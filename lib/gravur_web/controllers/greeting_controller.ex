defmodule GravurWeb.GreetingController do
  use GravurWeb, :controller

  def index(conn, _params) do
    user = Gravur.Identity.current_user(conn)
    greetings = Gravur.Guest.get_all_greetings(user)
    render(conn, "index.html", greetings: greetings)
  end

  def new(conn, _params) do
    render(conn, "new.html", changeset: conn)
  end

  def create(conn, %{"greeting" => greeting_params}) do
    user = Gravur.Identity.current_user(conn)
    book = Gravur.Operator.get_book(greeting_params[:book_id])
    case Gravur.Guest.create_greeting(greeting_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have successfully created a greeting!")
        |> redirect(to: GravurWeb.Router.Helpers.book_greeting_path(GravurWeb.Endpoint, :index, book))

      {:error, changeset} ->
      render(conn, "new.html", changeset: changeset)
    end
  end
end