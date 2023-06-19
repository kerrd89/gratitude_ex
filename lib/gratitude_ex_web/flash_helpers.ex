defmodule GratitudeExWeb.FlashHelpers do
  @moduledoc """
  Helpers to manage flashes with timeouts and other conditions.
  """

  import Phoenix.LiveView.Utils, only: [put_flash: 3]
  use Phoenix.Component

  def put_flash_with_timeout(socket, kind, msg, timeout \\ 5000) do
    Process.send_after(self(), {:clear_flash, kind}, timeout)
    put_flash(socket, kind, msg)
  end

  attr :class, :string, doc: "Additional classes to add to the outer div"
  attr :flash_type, :atom, required: true, doc: ":success, :error, or :notice"
  attr :msg, :string, doc: "Message to display within the banner"
  attr :margin, :string, default: "mx-8 mt-24 mb-7 md:mt-7"
  attr :parent, :any, doc: "Target LiveView to handle closing the banner"

  def flash_banner(assigns) do
    assigns =
      assigns
      |> assign(:background_color, get_background_color(assigns.flash_type))
      |> assign(:text_color, get_text_color(assigns.flash_type))

    ~H"""
    <div
      class={[
        "flash-#{@flash_type}",
        "flash-alert",
        "flex w-full",
        if(is_nil(@msg) || @msg == "", do: "hidden"),
        if(Map.get(assigns, :class), do: @class)
      ]}
      role="alert"
    >
      <div class={[
        "flex flex-row w-full rounded-md justify-between items-center",
        @background_color,
        @text_color,
        @margin
      ]}>
        <span class="grow px-5 py-2 text-xs font-normal">
          <%= @msg %>
        </span>
        <button
          class="px-4 text-sm material-symbols"
          phx-click="lv:clear-flash"
          phx-value-key={@flash_type}
          phx-target={if Map.get(assigns, :parent), do: @parent, else: nil}
        >
          close
        </button>
      </div>
    </div>
    """
  end

  # We need to do this to make Tailwind happy. If classes aren't completely spelled out, they
  # won't end up in the compiled CSS.
  defp get_background_color(:success), do: "bg-vibrant-green-100-20%"
  defp get_background_color(:error), do: "bg-vibrant-red-50-20%"
  defp get_background_color(_), do: "bg-vibrant-blue-50-40%"
  defp get_text_color(:success), do: "text-vibrant-green-500"
  defp get_text_color(:notice), do: "text-vibrant-blue-500"
  defp get_text_color(:error), do: "text-vibrant-red-600"
  defp get_text_color(_), do: "text-grey-500"
end
