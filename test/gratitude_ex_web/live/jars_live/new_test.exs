defmodule GratitudeExWeb.JarsLive.NewTest do
  use GratitudeExWeb.LiveCase, async: true

  setup :register_and_log_in_user

  test "renders the new jar form", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/jars/new")

    assert has_element?(view, "h1", "Add Jar")
    assert has_element?(view, "button#save-new-jar", "Save")
    assert has_element?(view, "a#cancel-add-jar", "Cancel")
  end

  test "creates a jar with default values", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/jars/new")

    valid_attrs = %{
      title: Faker.Lorem.word(),
      send_summary?: true,
      send_summary_method: :in_app,
      goal_entry_count: Enum.random(1..20),
      goal_interval: :weekly
    }

    {:ok, _view, _html} =
      view
      |> form("#add-jar", jar: valid_attrs)
      |> render_submit(valid_attrs)
      |> follow_redirect(conn)
  end
end
