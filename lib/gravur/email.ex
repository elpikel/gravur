defmodule Gravur.Email do
  use Bamboo.Phoenix, view: Gravur.EmailView

  def verify_email(conn, user) do
    new_email()
    |> to(user.email)
    |> from("mailgun@sandbox8105b95b353e4017977fadc6f864f2e3.mailgun.org")
    |> subject("Welcome!")
    |> render("verify.html", conn: conn, user: user)
    |> Gravur.Externals.Mailer.deliver_later
  end
end