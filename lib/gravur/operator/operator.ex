defmodule Gravur.Operator do
  alias Gravur.Repo
  alias Gravur.Operator.Book

  def get_all_books(user) do
    user = Repo.preload(user, :books)
    user.books
  end

  def create_book(book_params) do
    Book.changeset(%Book{}, book_params) |> Repo.insert()
  end
end