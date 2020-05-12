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
end
