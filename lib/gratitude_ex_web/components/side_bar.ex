defmodule GratitudeExWeb.Components.SideBar do
  @moduledoc """
  Module that controls the SideBar Phoenix component and its mobile/desktop behaviors.
  """
  use GratitudeExWeb, :html

  # alias GratitudeEx.SettingsLibrary.Authz
  alias Phoenix.LiveView.JS

  def side_bar(assigns) do
    ~H"""
    <div class={[
      "absolute z-50 flex h-20 w-full flex-col justify-center bg-white shadow md:hidden",
      if(@debug_info, do: "border-t-8 #{@debug_info.light_t_border_color}")
    ]}>
      <div class="absolute md:hidden text-start h-6 left-6" phx-click={open_mobile_nav()}>
        <.live_component id="mobile-open" module={icon_atom_to_module(:menu)} />
      </div>

      <.current_page_heading current_path={@path} class="absolute left-16" />
    </div>

    <%!-- This overlay darkens the main content area when the mobile sidebar is opened --%>
    <div
      id="overlay"
      class="invisible opacity-0 transition-opacity fixed w-full top-0 left-0 backdrop-brightness-50"
    >
    </div>

    <div
      id="side-bar-container"
      class={[
        "border-grey-100 transition-sidebar group absolute z-40 flex h-screen max-w-0 flex-col items-center justify-between bg-white py-12 shadow-lg md:static md:max-w-[5rem] md:border-r md:shadow-none md:hover:max-w-[12rem]",
        if(@debug_info,
          do: "border-t-0 md:border-t-8 #{@debug_info.dark_t_border_color}"
        )
      ]}
      phx-click-away={close_mobile_nav()}
    >
      <div :if={@debug_info} class="absolute top-6 flex w-full justify-center">
        <div class={["rounded px-3", @debug_info.bg_color]}>
          <p class={["text-xxs font-semibold uppercase leading-4", @debug_info.text_color]}>
            <%= gettext("%{env_name}", env_name: @debug_info.env_name) %>
          </p>
        </div>
      </div>
      <div
        id="links-container"
        class="flex flex-col w-full invisible opacity-0 md:visible md:opacity-100"
      >
        <.link navigate={~p"/jars"}>
          <.live_component id="main-home-icon" module={GratitudeExWeb.Icons.PrimaryJarIcon} />
        </.link>
        <.authorized_side_bar_links path={@path} current_user={@current_user} />
      </div>

      <div id="profile-container" class="flex px-4 invisible opacity-0 md:visible md:opacity-100">
        <button class="flex flex-col max-w-[12rem] w-full font-semibold items-center group/profile hover:bg-grey-200 p-2 hover:bg-vibrant-blue-50-40% rounded-lg relative">
          <%!-- <div class="flex items-center justify-center h-12 w-12 min-w-[3rem] rounded-full bg-grey-50 group-hover/profile:text-vibrant-blue-700">
            <Icons.user class="h-7 w-7" />
          </div> --%>
          <.live_component id="side-bar-more-options" module={icon_atom_to_module(:manage_account)} />
          <p class="max-w-[12rem] w-full md:invisible md:opacity-0 md:group-hover:visible md:group-hover:opacity-100 transition-sidebar text-xs truncate mt-4 text-grey-800 group-hover/profile:text-vibrant-blue-700">
            <%= @current_user.email %>
          </p>

          <.user_menu current_user={@current_user} />
        </button>
      </div>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :path, :string, required: true
  attr :to, :string, required: true
  attr :icon, :atom, required: true, doc: "A function in `GratitudeExWeb.Components.Icons`"

  defp side_bar_link(assigns) do
    assigns = assign(assigns, :is_active, active?(assigns.path, assigns.to))

    ~H"""
    <.link
      navigate={@to}
      class={[
        "flex w-full items-center text-grey-1000 hover:bg-vibrant-blue-50-40% hover:text-vibrant-blue-700 px-3 py-2 mb-4 rounded-lg",
        if(@is_active, do: "bg-vibrant-blue-50-40%")
      ]}
    >
      <div class={[
        "flex font-normal text-2xl h-6 w-6 min-w-[1.5rem]",
        if(@is_active, do: "font-medium text-vibrant-blue-500")
      ]}>
        <.live_component
          id={"side-bar-link-#{Atom.to_string(@icon)}"}
          module={icon_atom_to_module(@icon)}
        />
      </div>
      <p class={[
        "side-bar-link-label",
        "flex md:invisible md:opacity-0 md:group-hover:visible md:group-hover:opacity-100 transition-sidebar ml-3 font-normal text-xs whitespace-nowrap",
        if(@is_active, do: "font-medium text-vibrant-blue-500")
      ]}>
        <%= @label %>
      </p>
    </.link>
    """
  end

  defp user_menu(assigns) do
    ~H"""
    <div
      class="absolute left-24 bottom-12 mt-2 border border-vibrant-blue-700-20% rounded-lg shadow-lg bg-white ring-1 ring-black ring-opacity-5 focus:outline-none hidden group-hover/profile:block z-10 text-left"
      id="user-menu"
      role="menu"
      aria-orientation="vertical"
      aria-labelledby="menu-button"
      tabindex="-1"
    >
      <div class="flex flex-col text-sm">
        <div class="flex flex-col font-medium text-vibrant-blue-400 mx-2 my-3 gap-y-3 items-start w-full">
          <.button kind="menu" icon={:user} href={~p"/account"}>
            <%= gettext("Settings") %>
          </.button>
          <.button kind="menu" icon={:login_logout} href={~p"/users/log_out"} method="delete">
            <%= gettext("Sign Out") %>
          </.button>
        </div>
      </div>
    </div>
    """
  end

  defp authorized_side_bar_links(assigns) do
    ~H"""
    <div class="flex flex-col mt-8 border-b border-grey-100 px-4">
      <.side_bar_link to={~p"/jars"} icon={:jars_list} label={gettext("Jars")} path={@path} />
      <.side_bar_link
        to={~p"/notifications"}
        icon={:notification}
        label={gettext("Notifications")}
        path={@path}
      />
    </div>
    """
  end

  defp open_mobile_nav(js \\ %JS{}) do
    js
    |> JS.hide(to: "#mobile-open")
    |> JS.show(to: "#mobile-close")
    |> JS.show(to: "#mobile-logo")
    |> JS.add_class("max-w-[12rem]", to: "#side-bar-container")
    |> JS.remove_class("max-w-0", to: "#side-bar-container")
    |> JS.remove_class("invisible opacity-0", to: "#overlay")
    |> JS.remove_class("invisible opacity-0", to: "#links-container")
    |> JS.remove_class("invisible opacity-0", to: "#profile-container")
  end

  defp close_mobile_nav(js \\ %JS{}) do
    js
    |> JS.hide(to: "#mobile-close")
    |> JS.show(to: "#mobile-open")
    |> JS.hide(to: "#mobile-logo")
    |> JS.add_class("max-w-0", to: "#side-bar-container")
    |> JS.remove_class("max-w-[12rem]", to: "#side-bar-container")
    |> JS.add_class("invisible opacity-0", to: "#overlay")
    |> JS.add_class("invisible opacity-0", to: "#links-container")
    |> JS.add_class("invisible opacity-0", to: "#profile-container")
  end

  def active?(current_path, to) when is_binary(current_path) and is_binary(to),
    do: String.starts_with?(current_path, to)

  defp icon_atom_to_module(:jars_list), do: GratitudeExWeb.Icons.JarsList
  defp icon_atom_to_module(:notification), do: GratitudeExWeb.Icons.Notification
  defp icon_atom_to_module(:mange_account), do: GratitudeExWeb.Icons.MoreOptions
  defp icon_atom_to_module(:manage_account), do: GratitudeExWeb.Icons.ManageAccount
  defp icon_atom_to_module(:menu), do: GratitudeExWeb.Icons.Menu
end
