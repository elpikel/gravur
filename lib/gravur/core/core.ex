defmodule Gravur.Core do
  alias Gravur.Repo
  alias Gravur.Core.Greeting
  alias Gravur.Core.Book
  alias Gravur.Core.Template
  alias Gravur.Core.Order

  import Ecto.Query

  def create_order(order_params) do
    %Order{}
    |> Order.changeset(order_params)
    |> Repo.insert()
  end

  def get_all_greetings(book_id) do
    Greeting |> where(book_id: ^book_id) |> Repo.all()
  end

  def create_greeting(greeting_params) do
    Greeting.changeset(%Greeting{}, greeting_params) |> Repo.insert()
  end

  def upload_greeting_images(greeting, content) do
    Gravur.Utils.FileUploader.upload_greeting(greeting, content)

    Task.async(fn ->
      content = Gravur.Utils.Image.thumb(content, %{width: 400, height: 400})

      Gravur.Utils.FileUploader.upload_greeting_small(greeting, content)
    end)
  end

  def update_greeting(greeting_params) do
    Greeting
    |> Repo.get(greeting_params["id"])
    |> Greeting.changeset(greeting_params)
    |> Repo.update()
  end

  def update_book(book_params) do
    Book
    |> Repo.get(book_params["id"])
    |> Book.changeset(book_params)
    |> Repo.update()
  end

  def get_all_books(user_id) do
    Book |> where(user_id: ^user_id) |> preload(:template) |> preload(:greetings) |> Repo.all()
  end

  def create_book(book_params) do
    Book.changeset(%Book{}, book_params) |> Repo.insert()
  end

  def delete_book(book_id) do
    %Book{id: book_id} |> Repo.delete()
  end

  def has_book(user_id) do
    Book |> where(user_id: ^user_id) |> Repo.exists?()
  end

  def update_pdf(book, file_name) do
    Ecto.Changeset.change(book, pdf: file_name)
    |> Gravur.Repo.update!()
  end

  def get_book(book_id) do
    Repo.get_by(Book, id: book_id)
  end

  def get_book_with_template(book_id) do
    Repo.one(
      from b in Book,
        join: t in assoc(b, :template),
        preload: [template: t],
        where: b.id == ^book_id
    )
  end

  def get_book_with_greetings(book_id) do
    Repo.one(
      from b in Book,
        left_join: g in assoc(b, :greetings),
        left_join: t in assoc(b, :template),
        where: b.id == ^book_id,
        order_by: [desc: g.inserted_at],
        preload: [greetings: g, template: t]
    )
  end

  def get_templates do
    Template |> Repo.all()
  end
end
