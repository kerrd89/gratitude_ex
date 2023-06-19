defmodule GratitudeExWeb.Plugs.AssignDebugInfo do
  @moduledoc """
  A simple plug that sets an assign for `:debug_info` with the value of a
  map based on the current environment.
  """

  import Plug.Conn, only: [assign: 3]

  def init(opts), do: opts

  def call(%Plug.Conn{} = conn, _opts) do
    assign(conn, :debug_info, GratitudeExWeb.DebugInfoHelpers.get_debug_info())
  end
end
