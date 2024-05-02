defmodule GratitudeEx.Jars.Jar do
  @moduledoc """
  Jar
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias GratitudeEx.Jars.UserJarLink
  alias GratitudeEx.Notifications.Notification

  schema "jars" do
    field :title, :string
    field :send_summary?, :boolean, default: true
    field :send_summary_method, Ecto.Enum, values: [:in_app], default: :in_app
    field :goal_entry_count, :integer, default: 1

    field :goal_interval, Ecto.Enum,
      values: [:weekly, :monthly, :quarterly, :annually],
      default: :monthly

    has_many :user_jar_links, UserJarLink
    has_many :notifications, Notification

    timestamps()
  end

  @required ~w[title send_summary? send_summary_method goal_entry_count goal_interval]a

  @doc false
  def changeset(jar, attrs) do
    jar
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
