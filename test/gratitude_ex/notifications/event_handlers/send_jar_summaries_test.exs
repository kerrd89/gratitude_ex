defmodule GratitudeEx.Jobs.Notifications.SendJarSummariesTest do
  use GratitudeEx.DataCase, async: true

  alias GratitudeEx.Factory
  alias GratitudeEx.Jobs.Notifications.SendJarSummaries

  describe "perform/1" do
    test "success: creates a Notification record if no notifications have been sent" do
      jar = Factory.insert(:jar)
      user = Factory.create_user()
      _user_jar_link = Factory.insert(:user_jar_link, user_id: user.id, jar_id: jar.id)
      params = %{starting_jar_id: 1}
      assert {:ok, {:summaries_sent, 1}} == perform_job(SendJarSummaries, params)
    end
  end
end
