defmodule Gravur.Repo.Migrations.AddOrderTable do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :name, :string
      add :address1, :string
      add :address2, :string
      add :book_id, references(:books, type: :binary_id)
      add :user_id, references(:users)

      timestamps()
    end
  end
end
