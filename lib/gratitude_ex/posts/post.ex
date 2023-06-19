defmodule GratitudeEx.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias GratitudeEx.Jars.UserJarLink

  schema "posts" do
    field :text, :string

    belongs_to :user_jar_link, UserJarLink

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
