defmodule Gravur.Utils.BookPdf do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  def storage_dir(version, {file, scope}) do
    "uploads/book/#{scope.id}/pdf"
  end
end