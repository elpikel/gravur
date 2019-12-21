defmodule Gravur.Utils.GreetingImage do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  def storage_dir(version, {file, scope}) do
    "uploads/book/#{scope.book_id}/greetings"
  end
end