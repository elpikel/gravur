defmodule Gravur.Email do
  use Bamboo.Phoenix, view: Gravur.EmailView

  def verify_email(conn, user) do
    new_email(
      to: user.email,
      from: "gravur@gravur.herokuapp.com",
      subject: "Gravur"
    )
    |> render("verify.html", conn: conn, user: user)
    |> Gravur.Externals.Mailer.deliver_later()
  end

  def invite_to_guest_book(conn, owner, guest, book) do
    new_email(
      to: guest,
      from: "gravur@gravur.herokuapp.com",
      subject: "Gravur"
    )
    |> render("invite.html", conn: conn, owner: owner, book: book)
    |> Gravur.Externals.Mailer.deliver_later()
  end
end
