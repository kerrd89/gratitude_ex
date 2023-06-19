defmodule GratitudeEx.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :ack, :boolean, default: false, null: false
      add :message, :string, null: false
      add :type, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :jar_id, references(:jars)

      timestamps()
    end

    create index(:notifications, [:user_id])
  end
end
