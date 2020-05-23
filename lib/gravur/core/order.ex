defmodule Gravur.Core.Order do
  use Ecto.Schema

  import Ecto.Changeset

  schema "orders" do
    field :name, :string
    field :address1, :string
    field :address2, :string
    field :items, :integer, default: 1

    belongs_to :user, Gravur.Identity.User
    belongs_to :book, Gravur.Core.Book, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(order, attrs \\ %{}) do
    order
    |> cast(attrs, [:user_id, :book_id, :name, :items, :address1, :address2])
    |> validate_required([:user_id, :book_id, :name, :items, :address1, :address2])
  end

  def empty() do
    changeset(%__MODULE__{})
  end
end
