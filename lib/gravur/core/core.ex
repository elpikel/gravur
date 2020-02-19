defmodule Gravur.Core do
  alias Gravur.Repo
  alias Gravur.Core.Greeting
  alias Gravur.Core.Book
  alias Gravur.Core.Template

  import Ecto.Query

  def get_all_greetings(book_id) do
    Greeting |> where(book_id: ^book_id) |> Repo.all
  end

  def create_greeting(greeting_params) do
    Greeting.changeset(%Greeting{}, greeting_params) |> Repo.insert()
  end

  def get_all_books(user_id) do
    Book |> where(user_id: ^user_id) |> preload(:template) |> Repo.all
  end

  def create_book(book_params) do
    Book.changeset(%Book{}, book_params) |> Repo.insert()
  end

  def has_book(user_id) do
    Book |> where(user_id: ^user_id) |> Repo.exists?
  end

  def update_pdf(book, file_name) do
    Ecto.Changeset.change(book, pdf: %{ file_name: file_name, updated_at: nil }) |> Gravur.Repo.update!
  end

  def get_book(book_id) do
    Repo.get_by(Book, id: book_id)
  end

  def get_book_with_greetings(book_id) do
    Repo.one(from b in Book,
       left_join: g in assoc(b, :greetings),
       where: b.id == ^book_id,
       order_by: [desc: g.inserted_at],
       preload: [greetings: g])
  end

  def get_templates do
    Template |> Repo.all
  end
end