defmodule GratitudeEx.Repo.Migrations.CreateQuotes do
  use Ecto.Migration

  def change do
    create table(:quotes) do
      add :text, :string
      add :author, :string

      timestamps()
    end
  end
end
