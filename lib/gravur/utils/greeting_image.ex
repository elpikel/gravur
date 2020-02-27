defmodule Gravur.Utils.GreetingImage do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  def storage_dir(version, {file, scope}) do
    "uploads/book/#{scope.book_id}/greetings"
  end

  def url_or_default({nil, _greeting}) do
    "/images/book.svg"
  end

  def url_or_default(image_params) do
    url(image_params)
  end
end
