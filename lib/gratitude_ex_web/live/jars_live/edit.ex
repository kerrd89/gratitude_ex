defmodule GratitudeExWeb.JarsLive.Edit do
  @moduledoc """
  View jars view
  """
  use GratitudeExWeb, :live_view
  on_mount GratitudeExWeb.JarsLiveAuth

  alias GratitudeEx.Jars

  @impl true
  def mount(%{"jar_id" => jar_id}, _session, socket) do
    jar = Jars.get_jar!(jar_id)
    current_user = Map.get(socket.assigns, :current_user)

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:jar, jar)
      |> assign(:live_action, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("open_modal", _params, socket) do
    {:noreply, assign(socket, :live_action, :delete_jar)}
  end

  @impl true
  def handle_event("close_modal", _params, socket) do
    {:noreply, assign(socket, :live_action, nil)}
  end

  @impl true
  def handle_event("delete_jar", _params, socket) do
    jar = Map.get(socket.assigns, :jar)

    case Jars.delete_jar(jar) do
      {:ok, _jar} ->
        socket =
          socket
          |> assign(:live_action, nil)
          |> put_flash(:success, gettext("Jar %{title} has been deleted", title: jar.title))
          |> push_navigate(to: ~p"/jars")

        {:noreply, socket}

      {:error, _changeset} ->
        {:norelply, put_flash(socket, :error, gettext("Unable to delete Jar."))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section>
      <div class="flex flex-row justify-between mb-10 text-grey-800">
        <h1>Edit Jar</h1>
        <.link phx-click="open_modal">
          <div class="flex flex-row items-center">
            <span class="text-xs mr-2"><%= gettext("Delete Jar") %></span>
            <.live_component id="delete-jar-icon" module={GratitudeExWeb.Icons.TrashCan} />
          </div>
        </.link>
      </div>
      <.live_component
        id="edit-jar-form"
        module={GratitudeExWeb.JarsLive.AddEditJarForm}
        jar={@jar}
        current_user={@current_user}
      />

      <.form_modal
        :if={@live_action == :delete_jar}
        id="delete-jar-modal"
        return_to={~p"/jars/#{@jar.id}/edit"}
      >
        <div class="mb-5"><%= gettext("This cannot be reversed, are you sure?") %></div>
        <div class="flex flex-row justify-around">
          <.button
            id="cancel-delete-jar"
            kind="text"
            navigate={~p"/jars/#{@jar.id}/edit"}
            class="text-xs w-10 font-medium"
          >
            <%= gettext("Cancel") %>
          </.button>

          <.button
            class="bg-vibrant-red-700"
            id="delete-jar-button"
            phx-click="delete_jar"
            phx-disable-with={gettext("Deleting...")}
          >
            <span class="text-grey-50"><%= gettext("Delete") %></span>
          </.button>
        </div>
      </.form_modal>
    </section>
    """
  end
end
