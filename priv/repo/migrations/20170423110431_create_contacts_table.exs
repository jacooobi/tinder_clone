defmodule TinderClone.Repo.Migrations.CreateContactsTable do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :user_id, references(:users, on_delete: :nothing), primary_key: true
      add :contact_id, references(:users, on_delete: :nothing), primary_key: true
    end
  end
end
