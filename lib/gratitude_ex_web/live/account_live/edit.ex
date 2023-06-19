defmodule GratitudeExWeb.AccountLive.Edit do
  @moduledoc """
  LiveView for editing account details.
  """
  use GratitudeExWeb, :live_view

  alias GratitudeEx.Accounts
  alias GratitudeEx.Auth.User

  @impl Phoenix.LiveView
  def mount(_params, _session, socket), do: {:ok, assign_form(socket)}

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} id="account-settings-form" phx-change="validate" phx-submit="save">
        <div class="flex flex-col max-w-sm">
          <.input
            field={@form[:name]}
            label={gettext("Full Name")}
            placeholder={gettext("First Last Name")}
          />

          <div class="self-end">
            <%!-- <.button id="change-password" kind="text" navigate={~p"/account/change_password"}> --%>
            <%= gettext("Change Password") %>
            <%!-- </.button> --%>
          </div>

          <div class="flex flex-row mt-32 mb-10 items-center justify-end space-x-12">
            <.button id="reset" kind="text" type="reset" name="reset">
              <%= gettext("Reset") %>
            </.button>

            <.button id="submit" phx-disable-with={gettext("Saving...")}>
              <%= gettext("Save") %>
            </.button>
          </div>
        </div>
      </.form>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"_target" => ["reset"]}, socket) do
    {:noreply, assign_form(socket)}
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    current_user = socket.assigns.current_user

    changeset =
      current_user
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    current_user = socket.assigns.current_user

    case Accounts.update_user(current_user, user_params) do
      {:ok, %User{} = updated_current_user} ->
        socket =
          socket
          |> clear_flash()
          |> put_flash(:success, gettext("Successfully updated account."))
          |> assign(current_user: updated_current_user)

        {:noreply, socket}

      {:error, :unauthorized} ->
        {:noreply,
         put_flash(socket, :error, gettext("You are not authorized to perform this action."))}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = put_flash(socket, :error, gettext("Failed to update account."))

        {:noreply, assign_form(socket, changeset)}
    end
  end

  # build fresh Changeset if none was given
  defp assign_form(socket) do
    current_user = socket.assigns.current_user
    changeset = Accounts.change_user(current_user, %{})

    assign_form(socket, changeset)
  end

  defp assign_form(socket, changeset), do: assign(socket, :form, to_form(changeset))
end
