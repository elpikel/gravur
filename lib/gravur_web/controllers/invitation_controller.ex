defmodule GravurWeb.InvitationController do
  use GravurWeb, :controller
  alias Gravur.Identity

  def send(conn, %{"user_id" => user_id}) do
    user = Identity.get_user(user_id)
    Gravur.Email.invite_to_guest_book(conn, user)
  end
end
