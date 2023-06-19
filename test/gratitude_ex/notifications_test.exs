defmodule GratitudeEx.NotificationsTest do
  use GratitudeEx.DataCase

  alias GratitudeEx.Notifications
  alias GratitudeEx.Notifications.Notification
  alias GratitudeEx.Factory

  setup _context do
    user = Factory.create_user()
    {:ok, user: user}
  end

  describe "notifications" do
    @invalid_attrs %{ack: nil}

    test "list_notifications_for_user/0 returns all notifications", %{user: user} do
      notification = Factory.insert(:notification, user_id: user.id)
      assert Notifications.list_notifications_for_user(user.id) == [notification]
    end

    test "get_notification!/1 returns the notification with given id", %{user: user} do
      notification = Factory.insert(:notification, user_id: user.id)
      assert Notifications.get_notification!(notification.id) == notification
    end

    test "create_notification/1 with valid data creates a notification", %{user: user} do
      valid_attrs = %{
        ack: true,
        message: "This is a test message",
        type: Enum.random([:invitation, :alert, :info, :summary]),
        user_id: user.id
      }

      assert {:ok, %Notification{} = notification} =
               Notifications.create_notification(valid_attrs)

      assert notification.ack == true
      assert notification.message == valid_attrs[:message]
    end

    test "create_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notifications.create_notification(@invalid_attrs)
    end

    test "update_notification/2 with valid data updates the notification", %{user: user} do
      notification = Factory.insert(:notification, user_id: user.id)
      update_attrs = %{ack: false}

      assert {:ok, %Notification{} = notification} =
               Notifications.update_notification(notification, update_attrs)

      assert notification.ack == false
    end

    test "update_notification/2 with invalid data returns error changeset", %{user: user} do
      notification = Factory.insert(:notification, user_id: user.id)

      assert {:error, %Ecto.Changeset{}} =
               Notifications.update_notification(notification, @invalid_attrs)

      assert notification == Notifications.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification", %{user: user} do
      notification = Factory.insert(:notification, user_id: user.id)
      assert {:ok, %Notification{}} = Notifications.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_notification!(notification.id) end
    end

    test "change_notification/1 returns a notification changeset", %{user: user} do
      notification = Factory.insert(:notification, user_id: user.id)
      assert %Ecto.Changeset{} = Notifications.change_notification(notification)
    end
  end

  describe "ack_notification/2" do
    test "acks a notification", %{user: user} do
      notification = Factory.insert(:notification, user_id: user.id, ack: false)
      {:ok, %Notification{} = updated_notification} = Notifications.ack_notification(notification)
      assert updated_notification.ack != notification.ack
      assert updated_notification.ack
    end
  end
end
