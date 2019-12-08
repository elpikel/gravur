defmodule Gravur.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cover_title, :string
      add :cover_text, :string
      add :font_style, :string
      add :title_page_title, :string
      add :title_page_text, :string
      add :title_page_image, :string
      add :invitation_code, :uuid
      add :user_id, references(:users)

      timestamps()
    end

  end
end
