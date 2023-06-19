defmodule GratitudeExWeb.JarsLiveAuth do
  @moduledoc """
  LiveView mount hook to prevent the current user from accessing any resources under the
  "jar_id" in the params unless authorized to do so.
  """
  use GratitudeExWeb, :verified_routes

  import GratitudeExWeb.Gettext, only: [gettext: 1]
  import Phoenix.LiveView
  import Phoenix.Component

  alias GratitudeEx.Jars

  def on_mount(:default, %{"jar_id" => jar_id}, _session, socket) do
    current_user = socket.assigns.current_user

    case Jars.get_user_jar_link_by_user_and_jar(current_user.id, jar_id) do
      nil ->
        socket =
          socket
          |> put_flash(:error, gettext("You are not authorized to access that page"))
          |> redirect(to: ~p"/jars")

        {:halt, socket}

      user_jar_link ->
        # TODO: assign user jar link here
        {:cont, assign(socket, :user_jar_link, user_jar_link)}
    end
  end
end
