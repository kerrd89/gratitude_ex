defmodule GratitudeExWeb.NotificationsLive.IndexTest do
  use GratitudeExWeb.LiveCase, async: true

  setup :register_and_log_in_user

  alias GratitudeEx.Factory

  test "renders header and empty list page", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/notifications")

    assert has_element?(view, "h1", "Notifications")
  end

  test "renders notification", %{conn: conn, user: user} do
    notification = Factory.insert(:notification, user_id: user.id)
    {:ok, view, _html} = live(conn, ~p"/notifications")

    assert has_element?(
             view,
             "span#notification-message-#{notification.id}",
             notification.message
           )

    assert has_element?(view, "button#ack-button-notification-#{notification.id}", "Acknowledge")
  end

  test "can acknowledge a notification", %{conn: conn, user: user} do
    notification = Factory.insert(:notification, user_id: user.id)
    {:ok, view, _html} = live(conn, ~p"/notifications")

    view
    |> element("button#ack-button-notification-#{notification.id}", "Acknowledge")
    |> render_click()

    refute has_element?(view, "button#ack-button-notification-#{notification.id}", "Acknowledge")
  end

  test "renders many notifications", %{conn: conn, user: user} do
    notification_1 = Factory.insert(:notification, user_id: user.id)
    notification_2 = Factory.insert(:notification, user_id: user.id)
    notification_3 = Factory.insert(:notification, user_id: user.id)
    {:ok, view, _html} = live(conn, ~p"/notifications")

    assert has_element?(
             view,
             "span#notification-message-#{notification_1.id}",
             notification_1.message
           )

    assert has_element?(
             view,
             "span#notification-message-#{notification_2.id}",
             notification_2.message
           )

    assert has_element?(
             view,
             "span#notification-message-#{notification_3.id}",
             notification_3.message
           )
  end
end
