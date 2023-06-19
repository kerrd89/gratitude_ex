defmodule GratitudeExWeb.Hooks.DebugInfoHook do
  @moduledoc """
  LiveView hook to handle setting an assign for `:debug_info` with the value
  of a `GratitudeExWeb.DebugInfo` struct based on the current environment.
  """
  import Phoenix.Component, only: [assign: 3]

  def on_mount(:default, _params, _session, socket) do
    {:cont, assign(socket, :debug_info, GratitudeExWeb.DebugInfoHelpers.get_debug_info())}
  end
end
