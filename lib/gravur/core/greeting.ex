defmodule Gravur.Core.Greeting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "greetings" do
    field :image, Gravur.Utils.Image.Type
    field :signature, :string
    field :text, :string

    belongs_to :book, Gravur.Core.Book, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(greeting, attrs) do
    greeting
    |> cast(attrs, [:image, :text, :signature, :book_id])
    |> validate_required([:image, :text, :signature])
  end
end
