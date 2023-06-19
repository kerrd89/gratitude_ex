defmodule GratitudeEx.Notifications.EventHandlers.UserCreatedTest do
  use GratitudeEx.DataCase, async: true

  alias GratitudeEx.Factory
  alias GratitudeEx.Notifications.EventHandlers.UserCreated
  alias GratitudeEx.Notifications.Notification

  describe "perform/1" do
    test "success: creates a Notification record between the leap meter and site" do
      user = Factory.create_user()
      params = %{user_id: user.id}
      assert is_nil(Repo.get_by(Notification, user_id: user.id))

      Oban.Testing.with_testing_mode(:manual, fn ->
        assert :ok == perform_job(UserCreated, params)

        notification = Repo.get_by(Notification, user_id: user.id)
        assert notification.user_id == user.id
        assert notification.type == :info
        assert notification.message == "Welcome to Gratitude Jar. I hope this application helps you nuture gratitude in your own life as it has in mine."
        refute notification.ack
        assert is_nil(notification.jar_id)
      end)
    end
  end
end
