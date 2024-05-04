defmodule GratitudeEx.Notifications.EventHandlers.UserCreated do
  @moduledoc """
  Handle the `GratitudeEx.Events.UserCreated` event.
  """

  use Oban.Worker

  alias GratitudeEx.Notifications

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user_id" => user_id}}) do
    notification_params = %{
      ack: false,
      message:
        "Welcome to Gratitude Jar. I hope this application helps you nuture gratitude in your own life as it has in mine.",
      type: :info,
      user_id: user_id
    }

    case Notifications.create_notification(notification_params) do
      {:ok, _notification} ->
        :ok

      {:error, _changeset} ->
        {:cancel, :user_dne}
    end
  end
end
