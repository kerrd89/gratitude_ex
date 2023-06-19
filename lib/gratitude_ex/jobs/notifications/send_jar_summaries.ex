defmodule GratitudeEx.Jobs.Notifications.SendJarSummaries do
  @moduledoc """
  Checks for Jars which should send summaries.
  Sends summaries to the preferred delivery method for a user.
  """

  use Oban.Worker

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"starting_jar_id" => _starting_jar_id}}) do
    IO.inspect("==================== Attempting to send summaries using Oban.Cron ============")
    :ok
  end
end
