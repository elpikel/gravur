defmodule GravurWeb.VerificationController do
  use GravurWeb, :controller
  alias Gravur.Identity

  plug :put_layout, "login.html"

  def show(conn, %{"user_id" => user_id}) do
    user = Identity.get_user(user_id)
    render(conn, "email.html", user: user)
  end

  def send(conn, %{"user_id" => user_id}) do
    user = Identity.get_user(user_id)
    Gravur.Email.verify_email(conn, user)
    render(conn, "email.html", user: user)
  end

  def verify(conn, %{"user_id" => user_id, "verification_code" => verification_code}) do
    case Identity.verify(user_id, verification_code) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: GravurWeb.Router.Helpers.book_path(GravurWeb.Endpoint, :index))
      {:error, _changeset} ->
        render(conn, "wrong_verification_code.html")
    end
  end
end