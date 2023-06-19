defmodule GratitudeEx.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :text, :string
      add :user_jar_link_id, references(:user_jar_links, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:posts, [:user_jar_link_id])
  end
end
