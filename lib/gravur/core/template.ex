defmodule Gravur.Core.Template do
  use Ecto.Schema
  import Ecto.Changeset

  schema "templates" do
    field :name, :string

    has_many :books, Gravur.Core.Book

    timestamps()
  end

  @doc false
  def changeset(template, attrs) do
    template
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
