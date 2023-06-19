defmodule GratitudeExWeb.Components.Buttons do
  @moduledoc """
  Functions to render buttons.
  """
  use Phoenix.Component

  import GratitudeExWeb.Gettext

  alias GratitudeExWeb.Components.Icons

  @navigation_attrs ~w(csrf_token href method navigate patch replace)

  @doc """
  Renders a standard button.

  In order to preserve semantic meaning and take advantage of LiveView's link
  component, the underlying rendering logic is determined by the attributes
  present. `Phoenix.Component.link/1` is used for buttons that perform
  navigation and an HTML `<button>` is used otherwise.

  Attributes that indicate navigation include:

    * `csrf_token`
    * `href`
    * `method`
    * `navigate`
    * `patch`
    * `replace`

  See `Phoenix.Component.link/1` for more information on the behaviors tied to
  these attributes.

  ## Examples

      <.button kind="secondary">Next</.button>
      <.button phx-click="go" icon={:plus}>Add Installer</.button>
      <.button href={~p"/admin/installers"}>Cancel</.button>
  """

  attr :kind, :string, default: "primary", doc: "One of primary/secondary/text/auth/inline"
  attr :icon, :atom, default: nil, doc: "A function in `GratitudeExWeb.Components.Icons`"
  attr :class, :string, default: nil, doc: "Optional class overrides"
  attr :size, :string, default: "normal", doc: "One of normal/large"
  attr :rest, :global, include: ~w(disabled form name type value) ++ @navigation_attrs

  slot :inner_block, required: true

  @spec button(map()) :: Phoenix.LiveView.Rendered.t()
  def button(assigns) do
    if has_navigation_attr?(assigns) do
      render_link(assigns)
    else
      render_button(assigns)
    end
  end

  defp has_navigation_attr?(%{rest: rest}) do
    attr =
      rest
      |> Map.keys()
      |> Enum.find(&Enum.member?(@navigation_attrs, to_string(&1)))

    !is_nil(attr) and !is_nil(Map.get(rest, attr))
  end

  defp render_link(assigns) do
    assigns = assign_icon_args(assigns)

    ~H"""
    <.link class={[button_class(assigns), @class]} {@rest}>
      <%!-- <div :if={@icon} class="mr-2 h-6 w-6">
        <%= apply(Icons, @icon, [@icon_assigns]) %>
      </div> --%>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  defp render_button(assigns) do
    ~H"""
    <button class={[button_class(assigns), @class]} {@rest}>
      <div :if={@icon} class="mr-2 h-6 w-6">
        <%= apply(Icons, @icon, [@icon_assigns]) %>
      </div>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  @doc """
  Renders a tab button.

  ## Examples

      <.tab active>Installers</.tab>
      <.tab>Other</.tab>
  """

  attr :active, :boolean, default: false, doc: "Whether or not this tab is currently active"
  attr :class, :string, default: nil, doc: "Optional class overrides"
  attr :rest, :global, include: @navigation_attrs

  slot :inner_block, required: true, doc: "Tab label"

  @spec tab(map()) :: Phoenix.LiveView.Rendered.t()
  def tab(assigns) do
    ~H"""
    <.link class={tab_class(assigns)} {@rest}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  defp tab_class(assigns) do
    [
      "w-32 text-center",
      button_common(),
      button_spacing(assigns),
      tab_state(assigns),
      assigns.class
    ]
  end

  @doc """
  Renders a group of tabs.

  ## Examples

      <.tab_group>
        <.tab active><%= "Installers" %></.tab>
        <.tab><%= "Other" %></.tab>
        <.tab><%= "Another" %></.tab>
      </.tab_group>
  """
  slot :inner_block, required: true, doc: "<.tab> components to render within the tab group"

  @spec tab_group(map()) :: Phoenix.LiveView.Rendered.t()
  def tab_group(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders an icon button.

  Behaves as a standard button (see `button/1` doc above for reference)
  with additional `color` and `size` attributes.

  Includes an `sr_label` to accompany the standalone icon. This `sr_label`
  is required and contains a11y text for screen reader compatibility.

  ## Examples

      <.icon_button icon={:search} sr_label={"Search"} />
      <.icon_button icon={:user_add} href={~p"/users/create"} sr_label={"Add User"} />
      <.icon_button icon={:plus} phx-click="go" sr_label={"Add Installer"} />

  """

  attr :color, :string, default: "blue", values: ["blue", "grey", "orange", "white"]
  attr :icon, :atom, required: true, doc: "A function in `GratitudeExWeb.Components.Icons`"
  attr :rest, :global, include: ~w(disabled form name type value) ++ @navigation_attrs
  attr :size, :string, default: "normal", doc: "One of `normal` or `small`"
  attr :sr_label, :string, required: true, doc: "A label for screen readers"

  @spec icon_button(map()) :: Phoenix.LiveView.Rendered.t()
  def icon_button(assigns) do
    if has_navigation_attr?(assigns) do
      render_icon_link(assigns)
    else
      render_icon_button(assigns)
    end
  end

  defp render_icon_link(assigns) do
    assigns = assign_icon_args(assigns)

    ~H"""
    <.link class={icon_class(assigns)} {@rest}>
      <%= apply(Icons, @icon, [@icon_assigns]) %>
      <span class="sr-only"><%= @sr_label %></span>
    </.link>
    """
  end

  defp render_icon_button(assigns) do
    assigns = assign_icon_args(assigns)

    ~H"""
    <button class={icon_class(assigns)} {@rest}>
      <%= apply(Icons, @icon, [@icon_assigns]) %>
      <span class="sr-only"><%= @sr_label %></span>
    </button>
    """
  end

  # Remove `id` and `class` so they are not applied to the svg element
  defp assign_icon_args(assigns) do
    icon_assigns =
      assigns
      |> update(:rest, &Map.delete(&1, :id))
      |> Map.delete(:class)

    assign(assigns, :icon_assigns, icon_assigns)
  end

  @doc """
  Renders the "Back to {back_to_destination}" link to
  return to the passed `path` from the current page.

  ## Example

      <.back_to_link path={@index_path} back_to_destination="Sites" />
  """
  attr :back_to_destination, :string, default: "jars"
  attr :path, :string, required: true

  def back_to_link(assigns) do
    ~H"""
    <.button kind="text" icon={:arrow_narrow_left} href={@path} class="w-fit">
      <%= gettext("Back to %{destination}", destination: String.capitalize(@back_to_destination)) %>
    </.button>
    """
  end

  ## TailwindCSS helpers

  defp button_class(%{kind: kind, size: size} = assigns) do
    [
      "flex items-center",
      button_common(),
      button_colors(assigns),
      button_spacing(assigns),
      if(size == "large", do: "h-12"),
      if(kind == "auth", do: "text-sm", else: "text-xs"),
      if(kind != "menu", do: "justify-center")
    ]
  end

  defp button_colors(%{kind: kind}) when kind in ~w(primary auth) do
    """
    bg-vibrant-blue-50
    active:bg-vibrant-blue-50-40%
    disabled:bg-grey-50
    hover:bg-vibrant-blue-100
    text-vibrant-blue-600
    """
  end

  defp button_colors(%{kind: "secondary"}) do
    """
    bg-grey-100
    active:bg-grey-50
    disabled:bg-grey-50
    hover:bg-grey-200
    text-grey-1000
    """
  end

  defp button_colors(%{kind: "menu"}) do
    """
    disabled:bg-transparent
    hover:bg-vibrant-blue-50-15%
    text-vibrant-blue-600
    """
  end

  defp button_colors(%{kind: "text"}) do
    """
    active:bg-transparent
    disabled:bg-transparent
    hover:bg-vibrant-blue-100
    text-vibrant-blue-600
    active:text-vibrant-blue-400
    """
  end

  defp button_colors(%{kind: "inline"}) do
    """
    active:bg-transparent
    active:text-vibrant-blue-400
    text-vibrant-blue-600
    """
  end

  defp button_common do
    """
    focus:border-2
    focus:border-vibrant-blue-500
    disabled:cursor-not-allowed
    duration-150
    font-medium
    focus:outline-none
    rounded-lg
    disabled:text-grey-400
    text-xs
    transition-colors
    """
  end

  defp button_spacing(%{icon: icon, kind: "inline"}) when not is_nil(icon) do
    """
    px-0
    py-0
    """
  end

  defp button_spacing(%{icon: icon}) when not is_nil(icon) do
    """
    pr-6 focus:pr-[1.375rem]
    pl-4 focus:pl-3.5
    py-1 focus:py-0.5
    """
  end

  defp button_spacing(%{kind: "auth"}) do
    """
    px-6 focus:px-[1.375rem]
    py-4 focus:py-[0.9375rem]
    """
  end

  defp button_spacing(_assigns) do
    """
    px-6 focus:px-[1.375rem]
    py-2 focus:py-[0.375rem]
    """
  end

  defp tab_state(%{active: true}) do
    """
    bg-vibrant-blue-50
    active:border-transparent
    hover:cursor-default
    text-vibrant-blue-600
    """
  end

  defp tab_state(_assigns) do
    "bg-grey-100 hover:bg-grey-200 text-grey-1000"
  end

  defp icon_class(assigns) do
    [
      icon_color(assigns),
      icon_size(assigns)
    ]
  end

  defp icon_color(%{color: "grey"}) do
    """
    text-grey-1000
    disabled:cursor-not-allowed
    disabled:text-grey-400
    """
  end

  defp icon_color(%{color: "white"}) do
    """
    text-grey-50
    disabled:cursor-not-allowed
    """
  end

  defp icon_color(%{color: "orange"}) do
    """
    text-vibrant-orange-600
    disabled:cursor-not-allowed
    """
  end

  defp icon_color(_) do
    """
    text-vibrant-blue-500
    disabled:cursor-not-allowed
    disabled:text-vibrant-blue-100
    """
  end

  defp icon_size(%{size: "small"}), do: "h-5 w-5"
  defp icon_size(_), do: "h-6 w-6"
end
