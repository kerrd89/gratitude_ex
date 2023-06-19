defmodule GratitudeExWeb.JarsLive.JarSummaryCard do
  @moduledoc false
  use GratitudeExWeb, :live_component

  alias GratitudeEx.Jars

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_jar_score()
      |> assign_user_jar_link()
      |> assign_last_entry()

    {:ok, socket}
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div class="flex flex-row mx-5 border-2 rounded p-10 text-grey-700 mb-5">
      <%!-- TODO replace with a component which reflects their progress toward goals --%>
      <.live_component id={"jar-component-icon-#{@jar.id}"} module={get_icon_for_score(@jar_score)} />
      <div class="flex flex-col ml-10">
        <.link navigate={~p"/jars/#{@jar.id}"}>
          <div><%= gettext("%{title}", title: @jar.title) %></div>
        </.link>
        <div>
          <%= gettext("Progress toward goal %{goal_score}", goal_score: format_percentage!(@jar_score)) %>
        </div>
        <div :if={!is_nil(@last_entry)} class="mt-5 text-xs p-2 border-2 rounded">
          <%= to_date_string!(@last_entry.inserted_at) %>
          <%= gettext("%{text}", text: @last_entry.text) %>
        </div>
        <div :if={is_nil(@last_entry)} class="text-xs">
          <div class="mt-5"><%= gettext("Nothing in this Jar yet!") %></div>
        </div>
      </div>
    </div>
    """
  end

  defp assign_last_entry(%{assigns: %{user_jar_link: user_jar_link}} = socket) do
    last_entry =
      user_jar_link
      |> GratitudeEx.Repo.preload(:posts)
      |> Map.get(:posts)
      |> List.first()

    assign(socket, :last_entry, last_entry)
  end

  defp to_date_string!(date, opts \\ [format: :medium]) do
    Cldr.Date.to_string!(date, opts)
  end

  defp assign_user_jar_link(%{assigns: %{jar: jar, user_id: user_id}} = socket) do
    user_jar_link = Jars.get_user_jar_link_by_user_and_jar(user_id, jar.id)

    assign(socket, :user_jar_link, user_jar_link)
  end

  defp assign_jar_score(%{assigns: %{jar: jar, user_id: user_id}} = socket) do
    user_jar_link = Jars.get_user_jar_link_by_user_and_jar(user_id, jar.id)
    score = Jars.calculate_jar_goal_score(jar, user_jar_link)

    assign(socket, :jar_score, score)
  end

  defp get_icon_for_score(score) when score == 1.0, do: GratitudeExWeb.Icons.FullJarIcon
  defp get_icon_for_score(score) when score >= 0.75, do: GratitudeExWeb.Icons.AlmostFullJarIcon
  defp get_icon_for_score(score) when score >= 0.50, do: GratitudeExWeb.Icons.HalfFullJarIcon
  defp get_icon_for_score(score) when score >= 0.25, do: GratitudeExWeb.Icons.AlmostEmptyJarIcon
  defp get_icon_for_score(_score), do: GratitudeExWeb.Icons.EmptyJarIcon
end
