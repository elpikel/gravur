defmodule Gravur.Repo.Migrations.BookHasTemplate do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :template_id, references(:templates)
    end
  end
end
