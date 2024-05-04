defmodule GratitudeExWeb.JarsLive.Show do
  @moduledoc false
  use GratitudeExWeb, :live_view
  on_mount GratitudeExWeb.JarsLiveAuth

  alias GratitudeEx.Jars
  alias GratitudeEx.Posts
  alias GratitudeEx.Repo

  @impl true
  def mount(%{"jar_id" => jar_id} = _params, _session, socket) do
    jar = Jars.get_jar!(jar_id)
    # TODO: filter this posts query to include just posts for this user
    user_jar_link_preloaded = Repo.preload(socket.assigns.user_jar_link, [:posts])

    socket =
      socket
      |> assign(:jar, jar)
      |> assign(:user_jar_link, user_jar_link_preloaded)
      |> assign(:live_action, nil)
      |> assign(:delete_map, get_delete_map())

    {:ok, socket}
  end

  @impl true
  def handle_event("open_modal", params, socket) do
    socket =
      params
      |> Map.get("case", "add")
      |> case do
        "add" ->
          assign(socket, :live_action, :add_entry)

        "edit" ->
          edit_entry_id =
            params
            |> Map.get("post_id", "0")
            |> String.to_integer()

          socket
          |> assign(:live_action, :edit_entry)
          |> assign(:edit_entry_id, edit_entry_id)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("open_invite_modal", _params, socket) do
    socket = assign(socket, :live_action, :invite_user)

    {:noreply, socket}
  end

  @impl true
  def handle_event("close_modal", _params, socket) do
    {:noreply, assign(socket, :live_action, nil)}
  end

  @impl true
  def handle_event("delete_post", _params, socket) do
    socket =
      socket
      |> assign(:delete_map, %{
        delete_event: "confirm_delete_post",
        delete_text: "Confirm Delete"
      })

    {:noreply, socket}
  end

  @impl true
  def handle_event("confirm_delete_post", params, socket) do
    post_id = Map.get(params, "delete_id") |> String.to_integer()
    post = Posts.get_post!(post_id)

    case Posts.delete_post(post) do
      {:ok, _post} ->
        socket =
          socket
          |> assign(:live_action, nil)
          |> put_flash(:success, gettext("Post deleted."))
          |> push_navigate(to: ~p"/jars/#{socket.assigns.jar.id}")

        {:noreply, socket}

      {:error, _changeset} ->
        {:norelply, put_flash(socket, :error, gettext("Unable to delete Post."))}
    end
  end

  def jar_header(assigns) do
    ~H"""
    <div id="jar-header" class="flex flex-col mb-7 text-grey-800">
      <div class="flex flex-row justify-between">
        <p class="mb-3 text-xl"><%= @name %></p>
        <div class="flex flex-row">
          <.button id="add-post" phx-click="open_modal">
            <%!-- <.live_component id="add-new-post-icon" module={GratitudeExWeb.Icons.PostAdd} /> --%>
            <span><%= gettext("Add Entry") %></span>
          </.button>
          <.button id="edit-jar" class="rounded-full" navigate={~p"/jars/#{@jar_id}/edit"}>
            <span class="text-xs"><%= gettext("Edit Jar") %></span>
            <%!-- <.live_component id="edit-jar-icon" module={GratitudeExWeb.Icons.Edit} /> --%>
          </.button>
          <.button id="invite-user" class="rounded-full" phx-click="open_invite_modal">
            <span class="text-xs"><%= gettext("Collaborate") %></span>
            <%!-- <.live_component id="edit-jar-icon" module={GratitudeExWeb.Icons.Edit} /> --%>
          </.button>
        </div>
      </div>
    </div>
    """
  end

  defp get_delete_map() do
    %{
      delete_event: "delete_post",
      delete_text: "Delete",
      delete_id: nil
    }
  end
end
