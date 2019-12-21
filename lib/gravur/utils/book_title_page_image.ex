defmodule Gravur.Utils.BookTitlePageImage do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  def storage_dir(_version, {_file, scope}) do
    "uploads/user/#{scope.user_id}/book_title_page_image"
  end
end