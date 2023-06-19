defmodule GratitudeExWeb.NotificationsLive.Index do
  @moduledoc """
  View notifications view
  """
  use GratitudeExWeb, :live_view

  alias GratitudeEx.Notifications

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    socket =
      socket
      |> assign(:notifications, Notifications.list_notifications_for_user(current_user.id))

    {:ok, socket}
  end

  @impl true
  def handle_event("ack", %{"notification_id" => notification_id}, socket) do
    notification =
      Enum.find(socket.assigns.notifications, &(&1.id == String.to_integer(notification_id)))

    socket =
      notification
      |> Notifications.ack_notification()
      |> case do
        {:ok, _notification} ->
          socket
          |> put_flash(:success, "Notification acked.")
          |> assign(
            :notifications,
            Notifications.list_notifications_for_user(socket.assigns.current_user.id)
          )

        {:error, _changeset} ->
          put_flash(socket, :error, "Unable to ack notification.")
      end

    {:noreply, socket}
  end
end
