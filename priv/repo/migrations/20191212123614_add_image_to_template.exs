defmodule Gravur.Repo.Migrations.AddImageToTemplate do
  use Ecto.Migration

  def change do
    alter table(:templates) do
      add :image, :string
    end
  end
end
