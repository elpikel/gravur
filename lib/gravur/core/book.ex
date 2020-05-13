defmodule Gravur.Core.Book do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "books" do
    field :cover_text, :string
    field :cover_title, :string
    field :font_style, :string
    field :pdf, :string

    belongs_to :user, Gravur.Identity.User
    belongs_to :template, Gravur.Core.Template
    has_many :greetings, Gravur.Core.Greeting, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:cover_title, :cover_text, :font_style, :user_id, :template_id, :pdf])
    |> validate_required([:cover_title, :cover_text, :font_style, :user_id, :template_id])
  end

  def pdf_url(book) do
    if Application.get_env(:gravur, :local_storage) do
      "/uploads/book/#{book.id}/#{book.pdf}"
    else
      s3 = Application.get_env(:ex_aws, :s3)

      "#{s3[:scheme]}#{s3[:host]}/#{System.get_env("S3_BUCKET")}/uploads/book/#{book.id}/#{
        book.pdf
      }"
    end
  end

  def pdf_path(book) do
    if Application.get_env(:gravur, :local_storage) do
      "uploads/book/#{book.id}/"
    else
      "#{System.get_env("S3_BUCKET")}/uploads/book/#{book.id}/"
    end
  end
end
