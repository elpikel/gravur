defmodule GravurWeb.OrderController do
  use GravurWeb, :controller

  plug GravurWeb.Authorize

  def confirmed(conn, %{"order_id" => order_id}) do
    render(conn, "confirmed.html", order_id: order_id)
  end

  def new(conn, %{"book_id" => book_id}) do
    book = Gravur.Core.get_book_with_template(book_id)

    render(conn, "new.html",
      changeset: Gravur.Core.Order.empty(),
      book: book,
      total: Gravur.Core.Template.total(1),
      total_with_delivery: Gravur.Core.Template.total_with_delivery(1)
    )
  end

  def create(conn, %{
        "order" => %{
          "name" => name,
          "items" => items,
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
           items: items,
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
        book = Gravur.Core.get_book_with_template(book_id)
        {items, _} = Integer.parse(items)

        render(conn, "new.html",
          changeset: changeset,
          book: book,
          total: Gravur.Core.Template.total(items),
          total_with_delivery: Gravur.Core.Template.total_with_delivery(items)
        )
    end
  end
end
