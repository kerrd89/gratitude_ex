defmodule GratitudeExWeb.JarsLive.IndexTest do
  use GratitudeExWeb.LiveCase, async: true

  setup :register_and_log_in_user

  alias GratitudeEx.Factory

  test "redirects to jars if authenticated", %{conn: conn} do
    assert {:error, {:redirect, %{flash: %{}, to: "/jars"}}} = live(conn, ~p"/")
  end

  test "renders no jars page", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/jars")

    assert has_element?(view, "div#quote-section")
    assert has_element?(view, "div#no-jars-cta")
    assert has_element?(view, "a", "Add Jar")
    # TODO: assert some CTA which DNE
  end

  test "renders jars", %{conn: conn, user: user} do
    jar = Factory.insert(:jar)
    Factory.insert(:user_jar_link, user_id: user.id, jar_id: jar.id)
    {:ok, view, _html} = live(conn, ~p"/jars")

    assert has_element?(view, "div#jars-section")
    # TODO: assert around the jar card
  end

  test "clicking add jar redirects to jars/new", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/jars")

    assert element(view, "a", "Add Jar") |> render_click() |> follow_redirect(conn, ~p"/jars/new")
  end

  test "clicking a jar redirects to that jar page", %{conn: conn, user: user} do
    jar = Factory.insert(:jar)
    Factory.insert(:user_jar_link, user_id: user.id, jar_id: jar.id)
    {:ok, view, _html} = live(conn, ~p"/jars")

    view
    |> element("a[href^=\"/jars/#{jar.id}\"]")
    |> render_click()
    |> follow_redirect(conn, ~p"/jars/#{jar.id}")
  end
end
