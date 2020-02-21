defmodule GravurWeb.RegistrationController do
  use GravurWeb, :controller
  alias Gravur.Identity

  plug :put_layout, "login.html"

  def new(conn, _params) do
    render(conn, "new.html", changeset: conn)
  end

  def create(conn, %{"registration" => registration_params}) do
    case Identity.register(registration_params) do
      {:ok, user} ->
        Gravur.Email.verify_email(conn, user)
        redirect(conn, to: GravurWeb.Router.Helpers.verification_path(GravurWeb.Endpoint, :show, user.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end