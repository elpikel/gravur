defmodule Gravur.Repo.Migrations.TextInGreetingsToText do
  use Ecto.Migration

  def change do
    alter table(:greetings) do
      modify :text, :text
    end
  end
end
