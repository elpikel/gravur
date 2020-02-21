defmodule Gravur.Repo.Migrations.AddVerificationCodeToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :verification_code, :string
    end
  end
end
