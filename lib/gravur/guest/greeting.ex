defmodule Gravur.Guest.Greeting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "greetings" do
    field :image, :string
    field :signature, :string
    field :text, :string
    belongs_to :book, Gravur.Operator.Book

    timestamps()
  end

  @doc false
  def changeset(greeting, attrs) do
    greeting
    |> cast(attrs, [:image, :text, :signature])
    |> validate_required([:image, :text, :signature])
  end
end
