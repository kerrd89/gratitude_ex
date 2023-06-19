defmodule GratitudeEx.Jars.UserJarLink do
  use Ecto.Schema
  import Ecto.Changeset

  alias GratitudeEx.Auth.User
  alias GratitudeEx.Jars.Jar
  alias GratitudeEx.Posts.Post

  schema "user_jar_links" do
    field :role, Ecto.Enum, values: [:admin, :read, :write], default: :admin

    has_many :posts, Post, preload_order: [desc: :inserted_at]

    belongs_to :user, User
    belongs_to :jar, Jar

    timestamps()
  end

  @doc false
  def changeset(jar, attrs) do
    jar
    |> cast(attrs, [])
    |> validate_required([])
  end
end
