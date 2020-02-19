defmodule Gravur.Repo.Migrations.RemoveTitlePageFromBook do
  use Ecto.Migration

  def change do
    alter table("books") do
      remove :title_page_image
      remove :title_page_text
      remove :title_page_title
    end
  end
end
