defmodule Gravur.Core.Order do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "orders" do
    # TODO: add fields
    belongs_to :user, Gravur.Identity.User
    belongs_to :book, Gravur.Core.Book

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id, :book_id])
    |> validate_required([:user_id, :book_id])
  end
end
