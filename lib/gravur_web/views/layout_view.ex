defmodule GravurWeb.LayoutView do
  use GravurWeb, :view

  def current_path(conn) do
    Phoenix.Controller.current_path(conn)
  end

  def active?(conn, path) do
    if current_path(conn) == path, do: "active disabled", else: ""
  end
end
