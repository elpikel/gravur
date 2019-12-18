defmodule Gravur.Repo.Migrations.AddPdfToBook do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :pdf, :string
    end
  end
end
