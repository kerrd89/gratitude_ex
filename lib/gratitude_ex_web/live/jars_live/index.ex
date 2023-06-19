defmodule GratitudeExWeb.JarsLive.Index do
  @moduledoc """
  View jars view
  """
  use GratitudeExWeb, :live_view

  alias GratitudeEx.Jars
  alias GratitudeEx.Quotes

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:jars, Jars.list_jars())
      |> assign_gratitude_snippet()

    {:ok, assign(socket, :jars, Jars.list_jars())}
  end

  @impl true
  def handle_event("shuffle", _params, socket) do
    {:noreply, assign_gratitude_snippet(socket)}
  end

  defp assign_gratitude_snippet(socket) do
    assign(socket, :gratitude_quote, Quotes.get_random_quote!())
  end
end
