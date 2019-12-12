defmodule Gravur.Core.Template do
  use Ecto.Schema
  import Ecto.Changeset

  schema "templates" do
    field :name, :string
    field :image, :string

    has_many :books, Gravur.Core.Book

    timestamps()
  end

  @doc false
  def changeset(template, attrs) do
    template
    |> cast(attrs, [:name, :image])
    |> validate_required([:name, :image])
  end
end
