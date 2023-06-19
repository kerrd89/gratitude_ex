defmodule GratitudeExWeb.JarsLive.AddEditPostForm do
  @moduledoc false
  use GratitudeExWeb, :live_component

  alias GratitudeEx.Posts
  alias GratitudeEx.Posts.Post

  @impl true
  def update(assigns, socket) do
    post_id = Map.get(assigns, :post_id)

    post =
      if is_nil(post_id) do
        %Post{}
      else
        Posts.get_post!(post_id)
      end

    changeset = Posts.change_post(post)

    socket =
      socket
      |> assign(assigns)
      |> assign(:post, post)
      |> assign_form(changeset)
      |> assign(:delete_event, "delete_post")
      |> assign(:delete_text, "Delete")

    {:ok, socket}
  end

  @impl Phoenix.LiveComponent
  def handle_event("validate", %{"post" => post_params}, socket) do
    IO.inspect({"validating", post_params})
    post = Map.get(socket.assigns, :post)

    changeset =
      post
      |> Posts.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl Phoenix.LiveComponent
  def handle_event("save", %{"post" => post_params}, socket) do
    post = Map.get(socket.assigns, :post)

    socket =
      if !is_nil(post.id) do
        edit_post(socket, post, post_params)
      else
        create_post(socket, post_params)
      end

    {:noreply, socket}
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div class="flex-col">
      <.form
        class="mb-10"
        id="add-edit-post"
        for={@form}
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="mb-20">
          <.input
            type="textarea"
            field={@form[:text]}
            label={gettext("What are you grateful for?")}
            placeholder={gettext("Text for a post")}
            phx-debounce={false}
            required={true}
            aria-required
          />
        </div>
        <div class="flex flex-row items-center justify-end space-x-12">
          <.button
            id="cancel-add-post"
            kind="text"
            class="text-xs font-medium text-vibrant-blue-700"
            navigate={@return_to}
          >
            <%= gettext("Cancel") %>
          </.button>

          <.button
            disabled={not @form.source.valid?}
            id="save-post"
            phx-disable-with={gettext("Saving...")}
          >
            <%= if !is_nil(@post.id) do %>
              <%= gettext("Update Post") %>
            <% else %>
              <%= gettext("Add to Jar") %>
            <% end %>
          </.button>
        </div>
      </.form>
      <.button
        :if={!is_nil(@post.id)}
        class="bg-vibrant-red-500 text-xs"
        id="delete-jar-button"
        phx-click={Map.get(@delete_map, :delete_event, "delete")}
        phx-value-delete_id={@post.id}
      >
        <div class="flex flex-row items-center">
          <span class="text-xs text-grey-100 mr-2">
            <%= gettext("%{text}", text: Map.get(@delete_map, :delete_text)) %>
          </span>
          <.live_component id="delete-jar-icon" module={GratitudeExWeb.Icons.TrashCan} />
        </div>
      </.button>
    </div>
    """
  end

  defp create_post(socket, post_params) do
    user_jar_link_id =
      socket
      |> Map.get(:assigns)
      |> Map.get(:user_jar_link_id)

    case Posts.create_post(%Post{user_jar_link_id: user_jar_link_id}, post_params) do
      {:ok, _post} ->
        socket
        |> assign(:live_action, nil)
        |> put_flash(:success, gettext("Post created."))
        |> push_navigate(to: socket.assigns.return_to)

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> put_flash(:error, gettext("Unable to create Post."))
        |> assign_form(changeset)
        |> assign(:live_action, nil)
        |> push_navigate(to: socket.assigns.return_to)
    end
  end

  defp edit_post(socket, post, post_params) do
    case Posts.update_post(post, post_params) do
      {:ok, _post} ->
        socket
        |> assign(:live_action, nil)
        |> put_flash(:success, gettext("Post edited."))
        |> push_navigate(to: socket.assigns.return_to)

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> put_flash(:error, gettext("Unable to edit Post."))
        |> assign_form(changeset)
        |> assign(:live_action, nil)
        |> push_navigate(to: socket.assigns.return_to)
    end
  end

  defp assign_form(socket, changeset), do: assign(socket, :form, to_form(changeset))
end
