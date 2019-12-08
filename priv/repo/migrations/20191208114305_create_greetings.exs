defmodule Gravur.Repo.Migrations.CreateGreetings do
  use Ecto.Migration

  def change do
    create table(:greetings) do
      add :image, :string
      add :text, :string
      add :signature, :string
      add :book_id, references(:books)

      timestamps()
    end

  end
end
