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

  def get_book(book_id) do
    Repo.get_by(Book, id: book_id)
  end

  def get_book_with_greetings(book_id) do
    book = Repo.get_by(Book, id: book_id)
    Repo.preload(book, :greetings)
  end
end