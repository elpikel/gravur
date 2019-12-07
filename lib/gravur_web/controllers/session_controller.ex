defmodule GravurWeb.SessionController do
  use GravurWeb, :controller
  alias Gravur.Identity

  def new(conn, _params) do
    render conn, "new.html", changeset: conn
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Identity.sign_in(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "You have successfully signed in!")
        |> redirect(to: "/")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid Email or Password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Identity.sign_out()
    |> redirect(to: "/")
  end
end