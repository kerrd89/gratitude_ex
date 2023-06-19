defmodule GratitudeExWeb.Hooks.LocalNavHook do
  @moduledoc """
  LiveView hook to handle setting the current path within the session
  """

  import Phoenix.Component
  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    socket = attach_hook(socket, :path, :handle_params, &set_path/3)

    {:cont, socket}
  end

  defp set_path(_params, url, socket) do
    %{path: path} = URI.parse(url)
    {:cont, assign(socket, :path, path)}
  end
end
