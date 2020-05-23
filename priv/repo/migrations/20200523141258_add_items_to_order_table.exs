defmodule Gravur.Repo.Migrations.AddItemsToOrderTable do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :items, :integer, default: 1
    end
  end
end
