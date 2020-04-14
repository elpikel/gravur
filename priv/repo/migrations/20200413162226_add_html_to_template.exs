defmodule Gravur.Repo.Migrations.AddHtmlToTemplate do
  use Ecto.Migration

  def change do
    alter table(:templates) do
      add :html, :string
    end
  end
end
