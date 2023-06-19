defmodule GratitudeExWeb.JarsLive.ShowTest do
  use GratitudeExWeb.LiveCase, async: true

  setup :register_and_log_in_user

  alias GratitudeEx.Factory

  test "renders a jars page", %{conn: conn, user: user} do
    jar = Factory.insert(:jar)
    user_jar_link = Factory.insert(:user_jar_link, %{user_id: user.id, jar_id: jar.id})
    post = Factory.insert(:post, %{user_jar_link_id: user_jar_link.id})
    {:ok, view, _html} = live(conn, ~p"/jars/#{jar.id}")

    # TODO: maybe we do not want this here on this show jar page
    assert has_element?(view, "header", "Jars")
    assert has_element?(view, "div#jar-header", jar.title)
    assert has_element?(view, "button#add-post", "Add Entry")
    assert has_element?(view, "a#edit-jar", "Edit Jar")
    assert has_element?(view, "button#edit-post-#{post.id}", "Edit")
  end

  test "no jar exists", %{conn: conn, user: _user} do
    assert {:error,
            {:redirect,
             %{flash: %{"error" => "You are not authorized to access that page"}, to: "/jars"}}} ==
             conn
             |> live(~p"/jars/#{System.unique_integer([:positive])}")
  end

  test "can add posts", %{conn: conn, user: user} do
    jar = Factory.insert(:jar)
    Factory.insert(:user_jar_link, %{user_id: user.id, jar_id: jar.id})
    {:ok, view, _html} = live(conn, ~p"/jars/#{jar.id}")

    view
    |> element("button#add-post", "Add Entry")
    |> render_click()

    valid_attrs = %{
      text: Faker.Lorem.sentence()
    }

    {:ok, view, _html} =
      view
      |> form("#add-edit-post", post: valid_attrs)
      |> render_submit(valid_attrs)
      |> follow_redirect(conn)

    assert has_element?(view, "div.flash-success", "Post created.")
    assert has_element?(view, "span", valid_attrs[:text])
  end

  test "can edit a post", %{conn: conn, user: user} do
    jar = Factory.insert(:jar)
    user_jar_link = Factory.insert(:user_jar_link, %{user_id: user.id, jar_id: jar.id})
    post = Factory.insert(:post, %{user_jar_link_id: user_jar_link.id})
    {:ok, view, _html} = live(conn, ~p"/jars/#{jar.id}")

    view
    |> element("button#edit-post-#{post.id}", "Edit")
    |> render_click()

    valid_attrs = %{
      text: Faker.Lorem.sentence()
    }

    {:ok, view, _html} =
      view
      |> form("#add-edit-post", post: valid_attrs)
      |> render_submit(valid_attrs)
      |> follow_redirect(conn)

    assert has_element?(view, "div.flash-success", "Post edited.")
    assert has_element?(view, "span", valid_attrs[:text])
  end

  test "can delete a post", %{conn: conn, user: user} do
    jar = Factory.insert(:jar)
    user_jar_link = Factory.insert(:user_jar_link, %{user_id: user.id, jar_id: jar.id})
    post = Factory.insert(:post, %{user_jar_link_id: user_jar_link.id})
    {:ok, view, _html} = live(conn, ~p"/jars/#{jar.id}")

    view
    |> element("button#edit-post-#{post.id}", "Edit")
    |> render_click()

    assert has_element?(view, "button#delete-jar-button", "Delete")

    view
    |> element("button#delete-jar-button", "Delete")
    |> render_click()

    view
    |> element("button#delete-jar-button", "Confirm Delete")
    |> render_click()
    |> follow_redirect(conn, ~p"/jars/#{jar.id}")
  end

  @tag :skip
  test "only see posts authored by user" do
    # TODO: USER JAR LINKS HAVE MANY POSTS
  end

  @tag :skip
  test "can invite other user"

  @tag :skip
  test "can delete a jar"
end
