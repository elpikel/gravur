defmodule GravurWeb.InvitationController do
  use GravurWeb, :controller
  alias Gravur.Identity

  def send(conn, %{"user_id" => user_id, "book_id" => book_id, "name" => name}) do
    user = Identity.get_user(user_id)
    book = Gravur.Core.get_book(book_id)

    Gravur.Email.invite_to_guest_book(conn, name, user, book)

    json(conn, %{success: true})
  end
end
