defmodule GravurWeb.RegistrationController do
  use GravurWeb, :controller
  alias Gravur.Identity

  def new(conn, _params) do
    render conn, "new.html", changeset: conn
  end

  def create(conn, %{"registration" => registration_params}) do
    case Identity.register(registration_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: GravurWeb.Router.Helpers.book_path(GravurWeb.Endpoint, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end