defmodule Gravur.Email do
  use Bamboo.Phoenix, view: Gravur.EmailView

  def verify_email(conn, user) do
    new_email(
      to: user.email,
      from: "el.pikel@gmail.com",
      subject: "Gravur"
    )
    |> render("verify.html", conn: conn, user: user)
    |> Gravur.Externals.Mailer.deliver_now()
  end

  def invite_to_guest_book(conn, user) do
    new_email(
      to: user.email,
      from: "gravur@gravur.com",
      subject: "Gravur"
    )
    |> render("invite.html", conn: conn, user: user)
    |> Gravur.Externals.Mailer.deliver_later()
  end
end
