defmodule Gravur.Operator.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :cover_text, :string
    field :cover_title, :string
    field :font_style, :string
    field :invitation_code, Ecto.UUID
    field :title_page_image, :string
    field :title_page_text, :string
    field :title_page_title, :string

    belongs_to :user, Gravur.Identity.User
    belongs_to :template, Gravur.Operator.Template
    has_many :greetings, Gravur.Guest.Greeting

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:cover_title, :cover_text, :font_style, :title_page_title, :title_page_text, :title_page_image, :invitation_code])
    |> validate_required([:cover_title, :cover_text, :font_style, :title_page_title, :title_page_text, :title_page_image, :invitation_code])
  end
end
