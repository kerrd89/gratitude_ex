defmodule GratitudeEx.Jobs.Notifications.SendJarSummaries do
  @moduledoc """
  Checks for Jars which should send summaries.
  Sends summaries to the preferred delivery method for a user.
  """

  use Oban.Worker

  alias GratitudeEx.Jars
  alias GratitudeEx.Posts

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"starting_jar_id" => _starting_jar_id}}) do
    # cut_off = Posts.default_recent_date()
    # Jars.get_all_jars_for_summaries()
    # # |> Enum.filter(fn jar ->
    # #   last_notification = List.first(jar.notifications)
    # #   is_nil(last_notification) or DateTime.before?(last_notification.inserted_at, cut_off)
    # # end)
    # |> Enum.reduce(0, fn jar ->
    #   Posts.get_recent_posts_for_jar(jar.id)
    #   # TODO: there are many user_jar_links for each jar, we should send a notification to each user
    #   # notification_params = %{
    #   #   ack: false,
    #   #   message: "Welcome to Gratitude Jar. I hope this application helps you nuture gratitude in your own life as it has in mine.",
    #   #   type: :summary,
    #   #   user_id: user_id
    #   # }

    #   case Notifications.create_notification(notification_params) do
    #     {:ok, _notification} ->
    #       :ok
    #     {:error, _changeset} ->
    #       {:cancel, :user_dne}
    #     end

    #   Notifications.send_jar_summary
    # end)
    # IO.inspect("==================== Attempting to send summaries using Oban.Cron ============")
    # {:ok, {:summaries_sent, 0}}
  end
end
