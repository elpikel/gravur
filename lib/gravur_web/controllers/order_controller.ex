defmodule GravurWeb.OrderController do
  use GravurWeb, :controller

  plug GravurWeb.Authorize

  def confirmed(conn, _params) do
    render(conn, "confirmed.html")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, _params) do
    user_id = Gravur.Identity.current_user_id(conn)

    case Gravur.Core.create_order(%{user_id: user_id}) do
      {:ok, order} ->
        redirect(conn,
          to: GravurWeb.Router.Helpers.order_path(GravurWeb.Endpoint, :confirmed, order.id)
        )

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
