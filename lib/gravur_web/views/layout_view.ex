defmodule GravurWeb.LayoutView do
  use GravurWeb, :view

  def current_path(conn) do
    Phoenix.Controller.current_path(conn)
  end
end
