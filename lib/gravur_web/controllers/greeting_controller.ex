defmodule GravurWeb.GreetingController do
  use GravurWeb, :controller

  alias Gravur.Utils.Image

  plug :put_layout, "mobile.html"

  def index(conn, params) do
    book = Gravur.Core.get_book_with_greetings(params["book_id"])
    render(conn, "index.html", book: book)
  end

  def new(conn, params) do
    book = Gravur.Core.get_book(params["book_id"])
    render(conn, "new.html", changeset: conn, book: book)
  end

  def create(conn, %{"greeting" => %{"image" => image} = greeting_params, "book_id" => book_id}) do
    image_name = Image.random_filename(image.filename)
    greeting_params = Map.put(greeting_params, "book_id", book_id)
    greeting_params = Map.put(greeting_params, "image", image_name)

    case Gravur.Core.create_greeting(greeting_params) do
      {:ok, greeting} ->
        content = File.read!(image.path)

        Gravur.Core.upload_greeting_images(greeting, content)

        book = Gravur.Core.get_book(book_id)

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

  def create(conn, %{"greeting" => greeting_params, "book_id" => book_id}) do
    greeting_params = Map.put(greeting_params, "book_id", book_id)

    case Gravur.Core.create_greeting(greeting_params) do
      {:ok, _greeting} ->
        book = Gravur.Core.get_book(book_id)

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

  def update(conn, greeting_params) do
    case Gravur.Core.update_greeting(greeting_params) do
      {:ok, _} ->
        json(conn, %{success: true})

      {:error, _changeset} ->
        json(conn, %{success: false})
    end
  end
end
