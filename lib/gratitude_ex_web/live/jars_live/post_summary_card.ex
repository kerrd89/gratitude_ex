defmodule GratitudeExWeb.JarsLive.PostSummaryCard do
  @moduledoc false
  use GratitudeExWeb, :live_component

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:live_action, nil)

    {:ok, socket}
  end

  def humanized_time_since(datetime) do
    "#{datetime}"
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div class="flex flex-row justify-between border-2 rounded p-10 mb-5 text-grey-700">
      <div>
        <div><%= gettext("%{text}", text: @post.text) %></div>
        <div class="text-xs mt-10"><%= "#{humanized_time_since(@post.inserted_at)}" %></div>
      </div>
      <.button
        phx-click="open_modal"
        phx-value-post_id={@post.id}
        phx-value-case="edit"
        id={"edit-post-#{@post.id}"}
        class="max-h-10 my-auto"
      >
        <span id={"post-text-#{@post.id}"} class="text-xs mr-2"><%= gettext("Edit") %></span>
      </.button>
    </div>
    """
  end
end
