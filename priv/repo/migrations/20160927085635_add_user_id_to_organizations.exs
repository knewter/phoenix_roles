defmodule PhoenixRoles.Repo.Migrations.AddUserIdToOrganizations do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :user_id, references(:users)
    end
  end
end
