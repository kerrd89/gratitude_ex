defmodule GratitudeExWeb.NotificationsLive.NotificationSummaryCard do
  @moduledoc false
  use GratitudeExWeb, :live_component

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)

    {:ok, socket}
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div class="flex flex-row justify-between border-2 rounded p-10 mb-5 text-grey-700 whitespace-pre-line">
      <div id={"notification-message-#{@notification.id}"}>
        <%= @notification.message %>
      </div>
      <.button
        :if={!@notification.ack}
        id={"ack-button-notification-#{@notification.id}"}
        phx-click="ack"
        phx-value-notification_id={@notification.id}
      >
        <span class="text-xs mr-2"><%= gettext("Acknowledge") %></span>
      </.button>
    </div>
    """
  end
end
