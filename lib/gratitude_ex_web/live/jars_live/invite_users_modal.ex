defmodule GratitudeExWeb.JarsLive.InviteUsersModal do
  @moduledoc false
  use GratitudeExWeb, :live_component

  @impl true
  def update(assigns, socket) do
    socket = assign(socket, assigns)

    {:ok, socket}
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div class="flex-col">
      Potato
    </div>
    """
  end
end
