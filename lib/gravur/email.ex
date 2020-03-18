defmodule Gravur.Email do
  use Bamboo.Phoenix, view: Gravur.EmailView

  def verify_email(conn, user) do
    new_email(
      to: user.email,
      from: "gravur@gravur.com",
      subject: "Welcome",
      text_body: "test"
    )
    |> render("verify.html", conn: conn, user: user)
    |> Gravur.Externals.Mailer.deliver_later()
  end
end
