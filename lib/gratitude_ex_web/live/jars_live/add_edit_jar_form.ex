defmodule GratitudeExWeb.JarsLive.AddEditJarForm do
  @moduledoc false
  use GratitudeExWeb, :live_component

  alias GratitudeEx.Jars
  alias GratitudeEx.Jars.Jar

  @impl true
  def update(assigns, socket) do
    jar = Map.get(assigns, :jar, %Jar{})
    changeset = Jars.change_jar(jar)

    socket =
      socket
      |> assign(assigns)
      |> assign(:return_to, ~p"/jars")
      |> assign_form(changeset)

    {:ok, socket}
  end

  @impl Phoenix.LiveComponent
  def handle_event("validate", %{"jar" => jar_params}, socket) do
    jar = Map.get(socket.assigns, :jar, %Jar{})

    changeset =
      jar
      |> Jars.change_jar(jar_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl Phoenix.LiveComponent
  def handle_event("save", %{"jar" => jar_params}, socket) do
    jar = Map.get(socket.assigns, :jar, %Jar{})
    updated_jar_params = jar_params |> Map.put("user_jar_link", %{})

    socket =
      if !is_nil(jar.id) do
        edit_jar(socket, jar, updated_jar_params)
      else
        create_jar_for_user(socket, updated_jar_params)
      end

    {:noreply, socket}
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div class="flex-col ml-5 mr-5">
      <.form id="add-jar" for={@form} phx-target={@myself} phx-change="validate" phx-submit="save">
        <div class="mb-20">
          <.input
            type="text"
            field={@form[:title]}
            label={gettext("Label the jar")}
            placeholder={gettext("example: Family Jar")}
            value={@form[:title].value}
            required={true}
            aria-required
          />
          <section>
            <div class="mb-5 text-xl">Notifications</div>
            <.input
              type="checkbox"
              field={@form[:send_summary?]}
              label={gettext("Send me a monthly summary for this jar.")}
              aria-required
            />
            <div :if={to_boolean(@form[:send_summary?].value)}>
              <.input
                type="select"
                field={@form[:send_summary_method]}
                label={gettext("How would you like to receive those monthly summaries?")}
                options={[{"A notification in this application", :in_app}]}
                required={true}
                value={@form[:send_summary_method].value}
                aria-required
              />
            </div>
          </section>
          <section>
            <div class="mb-5 text-xl">Goals</div>
            <.input
              type="select"
              field={@form[:goal_interval]}
              label={gettext("How would you like to receive those monthly summaries?")}
              options={[
                {"Weekly", :weekly},
                {"Monthly", :monthly},
                {"Quarterly", :quarterly},
                {"Annually", :annually}
              ]}
              required={true}
              value={@form[:goal_interval].value}
              aria-required
            />
            <.input
              type="number"
              field={@form[:goal_entry_count]}
              label={
                gettext("How many posts would you like to aim for, %{interval}",
                  interval: @form[:goal_interval].value
                )
              }
              value={@form[:goal_entry_count].value}
              required={true}
              aria-required
            />
          </section>
        </div>
        <div class="flex flex-row items-center justify-end space-x-12">
          <.button
            id="cancel-add-jar"
            kind="text"
            navigate={@return_to}
            class="text-xs w-10 font-medium text-vibrant-blue-700"
          >
            <%= gettext("Cancel") %>
          </.button>

          <.button
            disabled={not @form.source.valid?}
            id="save-new-jar"
            phx-disable-with={gettext("Saving...")}
          >
            <%= gettext("Save") %>
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  defp create_jar_for_user(socket, jar_params) do
    user_id =
      socket
      |> Map.get(:assigns)
      |> Map.get(:current_user)
      |> Map.get(:id)

    updated_jar_params = Map.put(jar_params, "user_jar_link", %{})

    # TODO: pass user and create a user_jar_link
    case Jars.create_jar_for_user(%Jar{}, user_id, updated_jar_params) do
      {:ok, jar} ->
        socket
        |> put_flash(:success, success_message(jar))
        |> push_navigate(to: ~p"/jars/#{jar.id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> put_flash(:error, gettext("Unable to create Jar."))
        |> assign_form(changeset)
    end
  end

  defp edit_jar(socket, jar, jar_params) do
    case Jars.update_jar(jar, jar_params) do
      {:ok, jar} ->
        socket
        |> put_flash(:success, success_message(jar))
        |> push_navigate(to: ~p"/jars/#{jar.id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> put_flash(:error, gettext("Unable to edit Jar."))
        |> assign_form(changeset)
    end
  end

  defp success_message(%Jar{title: title}) do
    gettext("Jar %{title} has been created successfully.", title: title)
  end

  defp assign_form(socket, changeset), do: assign(socket, :form, to_form(changeset))

  defp to_boolean(true), do: true
  defp to_boolean(false), do: false
  defp to_boolean("true"), do: true
  defp to_boolean("false"), do: false
end
