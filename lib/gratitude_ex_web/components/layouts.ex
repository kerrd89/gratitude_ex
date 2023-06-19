defmodule GratitudeExWeb.Layouts do
  @moduledoc false
  use GratitudeExWeb, :html

  embed_templates "layouts/*"

  @doc """
  Returns the set of HTML classes for flash messages rendered in the
  unauthenticated layout.
  """
  @spec auth_flash_class(String.t()) :: [String.t()]
  def auth_flash_class(rest \\ "") do
    [
      """
      absolute top-12 left-1/2 -translate-x-1/2
      px-4 py-3
      rounded-md
      text-xs
      w-[20rem]
      """,
      rest
    ]
  end

  @doc """
  Returns the set of HTML classes for page gutters in the `:installer` layout.

  Accepts an atom of `:top` to indicate placement of the gutter.
  """
  @spec installer_gutter_class() :: String.t()
  def installer_gutter_class, do: "px-4 sm:px-12"

  @spec installer_gutter_class(atom()) :: String.t()
  def installer_gutter_class(:top), do: "pt-20 sm:pt-28"
end
