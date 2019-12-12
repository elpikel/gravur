defmodule Gravur.Core.Book do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "books" do
    field :cover_text, :string
    field :cover_title, :string
    field :font_style, :string
    field :title_page_image, Gravur.Utils.Image.Type
    field :title_page_text, :string
    field :title_page_title, :string

    belongs_to :user, Gravur.Identity.User
    belongs_to :template, Gravur.Core.Template
    has_many :greetings, Gravur.Core.Greeting

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:cover_title, :cover_text, :font_style, :title_page_title, :title_page_text, :user_id, :template_id])
    |> cast_attachments(attrs, [:title_page_image])
    |> validate_required([:cover_title, :cover_text, :font_style, :title_page_title, :title_page_text, :title_page_image, :user_id, :template_id])
  end
end
