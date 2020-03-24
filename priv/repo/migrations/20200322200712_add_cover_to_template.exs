defmodule Gravur.Repo.Migrations.AddCoverToTemplate do
  use Ecto.Migration

  def change do
    alter table(:templates) do
      add :cover, :string
    end
  end
end
