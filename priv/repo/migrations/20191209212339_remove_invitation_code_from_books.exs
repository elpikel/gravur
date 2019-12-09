defmodule Gravur.Repo.Migrations.RemoveInvitationCodeFromBooks do
  use Ecto.Migration

  def change do
    alter table(:books) do
      remove :invitation_code
    end
  end
end
