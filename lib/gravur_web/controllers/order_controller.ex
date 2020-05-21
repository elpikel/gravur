defmodule GravurWeb.OrderController do
  use GravurWeb, :controller

  plug GravurWeb.Authorize

  def confirmed(conn, _params) do
    render(conn, "confirmed.html")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{
        "order" => %{
          "name" => name,
          "address1" => address1,
          "address2" => address2
        },
        "book_id" => book_id
      }) do
    user_id = Gravur.Identity.current_user_id(conn)

    case Gravur.Core.create_order(%{
           user_id: user_id,
           book_id: book_id,
           name: name,
           address1: address1,
           address2: address2
         }) do
      {:ok, order} ->
        redirect(conn,
          to:
            GravurWeb.Router.Helpers.book_order_path(
              GravurWeb.Endpoint,
              :confirmed,
              book_id,
              order.id
            )
        )

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
