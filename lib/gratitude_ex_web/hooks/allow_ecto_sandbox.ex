defmodule GratitudeExWeb.Hooks.AllowEctoSandbox do
  @moduledoc """
  hook required for Wallaby-based end-to-end tests to function properly
  """

  import Phoenix.LiveView
  import Phoenix.Component

  def on_mount(:default, _params, _session, socket) do
    allow_ecto_sandbox(socket)
    {:cont, socket}
  end

  defp allow_ecto_sandbox(socket) do
    do_allow_ecto_sandbox(socket, configured_sandbox())
  end

  defp do_allow_ecto_sandbox(socket, nil), do: socket

  defp do_allow_ecto_sandbox(socket, sandbox) do
    %{assigns: %{phoenix_ecto_sandbox: metadata}} =
      assign_new(socket, :phoenix_ecto_sandbox, fn ->
        if connected?(socket), do: get_connect_info(socket, :user_agent)
      end)

    Phoenix.Ecto.SQL.Sandbox.allow(metadata, sandbox)
  end

  defp configured_sandbox() do
    Application.get_env(:gratitude_ex, :sandbox)
  end
end
