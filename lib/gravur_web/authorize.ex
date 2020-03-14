defmodule GravurWeb.Authorize do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if Gravur.Identity.user_signed_in?(conn) do
      conn
    else
      conn
      |> send_resp(401, "unauthorized")
      |> halt()
    end
  end
end
