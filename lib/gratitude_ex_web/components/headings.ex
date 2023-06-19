defmodule GratitudeExWeb.Components.Headings do
  @moduledoc """
  Functions to render headings.
  """
  use Phoenix.Component

  # alias GratitudeExWeb.Components.Icons

  import GratitudeExWeb.Gettext
  import Phoenix.HTML.Tag, only: [content_tag: 3]

  @doc """
  Renders a page heading.

  ## Examples

      <.page_heading icon={:user_group} text="Admin" />
  """
  attr :kind, :string, default: "dark", doc: "One of dark/light"
  attr :icon, :atom, required: true, doc: "A function in `GratitudeExWeb.Components.Icons`"
  attr :icon_kind, :string, default: "grey", doc: "One of grey/blue/outline"
  attr :icon_size, :string, default: "normal", doc: "One of normal/large"
  attr :level, :atom, default: :h1, doc: "Heading level"
  attr :text, :string, required: true, doc: "The text to display"
  attr :class, :string, default: nil, doc: "Optional class overrides"

  slot :inner_block, required: false

  @spec page_heading(map()) :: Phoenix.LiveView.Rendered.t()
  def page_heading(assigns) do
    ~H"""
    <header class={[page_heading_class(@kind), @class]}>
      <%!-- <div class={icon_class(@icon_kind, @icon_size)}>
        <%= apply(Icons, @icon, [Map.delete(assigns, :class)]) %>
      </div> --%>

      <%= heading(@level, @text) %>

      <%= render_slot(@inner_block) %>
    </header>
    """
  end

  @doc """
  Renders a page heading based on the current path.
  ## Examples
      <.current_page_heading current_path="/jars" />
  """
  attr :current_path, :string, required: true, doc: "Current jar path"
  attr :class, :string, default: nil, doc: "Optional class overrides"

  def current_page_heading(assigns) do
    ~H"""
    <%= apply(__MODULE__, :page_heading, [infer_page_heading_from_path(assigns)]) %>
    """
  end

  defp heading(level, text) do
    content_tag(level, text, class: "text-2xl leading-[1.125]")
  end

  defp page_heading_class(kind) do
    [
      "flex items-center gap-4",
      page_heading_colors(kind)
    ]
  end

  defp page_heading_colors("light"), do: "text-white antialiased"
  defp page_heading_colors(_kind), do: ""

  # defp icon_class(icon_kind, icon_size) do
  #   [
  #     "rounded-full",
  #     icon_colors(icon_kind),
  #     icon_size(icon_size)
  #   ]
  # end

  # defp icon_colors("blue") do
  #   """
  #   bg-vibrant-blue-50
  #   text-vibrant-blue-500
  #   """
  # end

  # defp icon_colors("grey") do
  #   """
  #   bg-grey-1000
  #   text-white
  #   """
  # end

  # defp icon_colors("outline") do
  #   """
  #   border border-white
  #   text-white
  #   """
  # end

  # defp icon_size("normal"), do: "h-8 w-8 p-1.5"
  # defp icon_size("large"), do: "h-10 w-10 p-2"

  @doc """
  Renders a list view heading.

  ## Examples

      <.list_view_heading icon={:wrench} title="Installer List" data={[{"Users", 7}]} />
  """
  attr :icon, :atom, required: true, doc: "A function in `GratitudeExWeb.Components.Icons`"
  attr :title, :string, required: true, doc: "The heading title"
  attr :data, :list, doc: "Key/value pairs to display"

  @spec list_view_heading(map()) :: Phoenix.LiveView.Rendered.t()
  def list_view_heading(assigns) do
    ~H"""
    <header class="flex items-center">
      <%!-- <div class="mr-2 h-6 w-6">
        <%= apply(Icons, @icon, [Map.delete(assigns, :class)]) %>
      </div> --%>

      <h2 class="mr-8 text-base font-medium"><%= @title %></h2>

      <dl class="flex items-center gap-4">
        <%= for {key, value} <- @data do %>
          <div class="flex items-center gap-2">
            <dt class="text-grey-800 text-sm"><%= key %></dt>
            <dd class="text-lg"><%= value %></dd>
          </div>
        <% end %>
      </dl>
    </header>
    """
  end

  defp infer_page_heading_from_path(%{current_path: path} = assigns),
    do: do_page_inference(path, assigns)

  defp do_page_inference("/jars" <> _rest, assigns),
    do: assign(assigns, text: gettext("Jars"), icon: :message_question)

  defp do_page_inference("/account" <> _rest, assigns),
    do: assign(assigns, text: gettext("Account"), icon: :user)

  defp do_page_inference(_path, assigns), do: assign(assigns, text: "Notifications", icon: :logo)
end
