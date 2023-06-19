defmodule GratitudeEx.Notifications.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  alias GratitudeEx.Auth.User
  alias GratitudeEx.Jars.Jar

  schema "notifications" do
    field :ack, :boolean, default: false
    field :message, :string
    field :type, Ecto.Enum, values: [:invitation, :summary, :alert, :info]

    belongs_to :user, User
    belongs_to :jar, Jar

    timestamps()
  end

  @required ~w[ack message type user_id]a
  @optional ~w[jar_id]a

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end

  @doc false
  def ack_changeset(notification, attrs) do
    notification
    |> cast(attrs, [:ack])
    |> validate_required([:ack])
  end
end
