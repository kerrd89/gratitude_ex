defmodule GratitudeEx.Jobs.Notifications.SendJarSummaries do
  @moduledoc """
  Checks for Jars which should send summaries.
  Sends summaries to the preferred delivery method for a user.
  """

  use Oban.Worker

  alias GratitudeEx.Jars
  alias GratitudeEx.Jars.UserJarLink
  alias GratitudeEx.Notifications
  alias GratitudeEx.Posts

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"starting_jar_id" => _starting_jar_id}}) do
    cut_off = Posts.default_recent_date()
    count_summary_notifications_sent = Jars.get_all_jars_for_summaries()
    |> Enum.filter(fn jar ->
      last_notification = List.first(jar.notifications)
      is_nil(last_notification) or DateTime.before?(last_notification.inserted_at, cut_off)
    end)
    |> Enum.reduce(0, fn jar, acc ->
      notification_message = jar.id |> Posts.get_recent_posts_for_jar() |> Posts.summarize_posts()

      dbg(notification_message)
      new_notification_count =
        Enum.reduce(jar.user_jar_links, 0, fn %UserJarLink{user_id: user_id}, acc ->
          notification_params = %{
            ack: false,
            message: notification_message,
            type: :summary,
            user_id: user_id
          }

          case Notifications.create_notification(notification_params) do
            {:ok, _notification} ->
              acc + 1

            {:error, _changeset} ->
              acc
          end
        end)

      acc + new_notification_count
    end)

    {:ok, {:summaries_sent, count_summary_notifications_sent}}
  end
end
