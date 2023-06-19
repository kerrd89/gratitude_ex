defmodule GratitudeExWeb.JarsLive.New do
  @moduledoc """
  View jars view
  """
  use GratitudeExWeb, :live_view

  alias GratitudeEx.Jars
  alias GratitudeEx.Jars.Jar

  @impl true
  def mount(_params, _session, socket) do
    jar_form =
      %Jar{}
      |> Jars.change_jar(%{})
      |> to_form()

    {:ok, assign(socket, :jar_form, jar_form)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section>
      <h1 class="mb-10">Add Jar</h1>
      <.live_component
        id="new-jar-form"
        module={GratitudeExWeb.JarsLive.AddEditJarForm}
        current_user={Map.get(assigns, :current_user)}
      />
    </section>
    """
  end
end
