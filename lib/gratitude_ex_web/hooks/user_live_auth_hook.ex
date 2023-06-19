defmodule GratitudeExWeb.Hooks.UserLiveAuthHook do
  @moduledoc """
  Auth module for LiveViews to leverage user tokens.
  """
  import Phoenix.LiveView
  import Phoenix.Component
  import GratitudeEx.Auth, only: [get_user_by_session_token: 1]

  def on_mount(:default, _params, %{"user_token" => user_token} = _session, socket) do
    socket = assign_new(socket, :current_user, fn -> get_user_by_session_token(user_token) end)

    if is_nil(socket.assigns.current_user) do
      {:halt, redirect(socket, to: "/users/log_in")}
    else
      {:cont, socket}
    end
  end
end
