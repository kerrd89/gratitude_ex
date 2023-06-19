defmodule GratitudeEx.Repo.Migrations.CreateJars do
  use Ecto.Migration

  def change do
    create table(:jars) do
      add :title, :string, null: false
      add :send_summary?, :boolean, null: false
      add :send_summary_method, :string, null: false
      add :goal_entry_count, :integer, null: false
      add :goal_interval, :string, null: false

      timestamps()
    end
  end
end
