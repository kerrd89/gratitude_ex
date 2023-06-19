defmodule GratitudeExWeb.Icons.MoreOptions do
  @moduledoc false
  use GratitudeExWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      id="menu"
      x="0"
      y="0"
      width="24px"
      version="1.1"
      viewBox="0 0 29 29"
      xml:space="preserve"
    >
      <circle cx="14.5" cy="14.5" r="2.5"></circle>
      <circle cx="4.5" cy="14.5" r="2.5"></circle>
      <circle cx="24.5" cy="14.5" r="2.5"></circle>
      <g>
        <circle cx="14.5" cy="14.5" r="2.5"></circle>
        <circle cx="4.5" cy="14.5" r="2.5"></circle>
        <circle cx="24.5" cy="14.5" r="2.5"></circle>
      </g>
    </svg>
    """
  end
end
