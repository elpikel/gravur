defmodule GravurWeb.InvitationController do
  use GravurWeb, :controller

  def send(conn, %{"book_id" => book_id, "name" => name, "people" => people}) do
    book = Gravur.Core.get_book(book_id)

    people
    |> String.split(" ")
    |> Enum.each(fn guest ->
      Gravur.Email.invite_to_guest_book(conn, name, guest, book)
    end)

    json(conn, %{success: true})
  end
end
