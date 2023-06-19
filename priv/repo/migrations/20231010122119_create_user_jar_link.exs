defmodule GratitudeEx.Repo.Migrations.CreateUserJarLink do
  use Ecto.Migration

  def change do
    create table(:user_jar_links) do
      add :jar_id, references(:jars, on_delete: :delete_all), null: false
      add :role, :string, null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create index(:user_jar_links, [:user_id])
    create index(:user_jar_links, [:jar_id])
  end
end
