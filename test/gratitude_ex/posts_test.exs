defmodule GratitudeEx.PostsTest do
  use GratitudeEx.DataCase

  alias GratitudeEx.Posts

  alias GratitudeEx.Factory

  alias GratitudeEx.Posts.Post

  @invalid_attrs %{text: nil}

  setup do
    jar = Factory.insert(:jar)
    user = Factory.create_user()
    user_jar_link = Factory.insert(:user_jar_link, %{jar_id: jar.id, user_id: user.id})
    {:ok, user_jar_link: user_jar_link, user: user}
  end

  test "list_posts/0 returns all posts", %{user_jar_link: user_jar_link} do
    post = Factory.insert(:post, %{user_jar_link_id: user_jar_link.id})
    assert Posts.list_posts() == [post]
  end

  test "get_post!/1 returns the post with given id", %{user_jar_link: user_jar_link} do
    post = Factory.insert(:post, %{user_jar_link_id: user_jar_link.id})
    assert Posts.get_post!(post.id) == post
  end

  describe "create_post/2" do
    test "with valid data creates a post", %{user_jar_link: user_jar_link} do
      valid_attrs = %{text: "some text"}

      assert {:ok, %Post{} = post} =
               Posts.create_post(%Post{user_jar_link: user_jar_link}, valid_attrs)

      assert post.text == "some text"
    end

    test "with invalid data returns error changeset", %{user_jar_link: user_jar_link} do
      assert {:error, %Ecto.Changeset{}} =
               Posts.create_post(%Post{user_jar_link: user_jar_link}, @invalid_attrs)
    end
  end

  describe "update_post/2" do
    test "with valid data updates the post", %{user_jar_link: user_jar_link} do
      post = Factory.insert(:post, %{user_jar_link: user_jar_link})
      update_attrs = %{text: "some updated text"}

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.text == "some updated text"
    end

    test "with invalid data returns error changeset", %{user_jar_link: user_jar_link} do
      post = Factory.insert(:post, %{user_jar_link_id: user_jar_link.id})
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end
  end

  describe "delete_post/1" do
    test "delete_post/1 deletes the post", %{user_jar_link: user_jar_link} do
      post = Factory.insert(:post, %{user_jar_link_id: user_jar_link.id})
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end
  end

  describe "change_post/1" do
    test "change_post/1 returns a post changeset", %{user_jar_link: user_jar_link} do
      post = Factory.insert(:post, %{user_jar_link_id: user_jar_link.id})
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end

  describe "get_recent_posts_for_jar/2" do
    test "returns posts within the default recent date range", %{user_jar_link: user_jar_link} do
      another_jar = Factory.insert(:jar)

      another_user_jar_link =
        Factory.insert(:user_jar_link, %{jar_id: another_jar.id, user_id: user_jar_link.user_id})

      today = Date.utc_today()

      invalid_updated_at =
        today
        |> Cldr.Calendar.plus(:months, -1)
        |> Cldr.Calendar.plus(:days, -1)
        |> DateTime.new!(Time.utc_now())

      valid_updated_at =
        today
        |> Cldr.Calendar.plus(:days, -1)
        |> DateTime.new!(Time.utc_now())

      edge_updated_at =
        today
        |> Cldr.Calendar.plus(:months, -1)
        |> DateTime.new!(Time.utc_now())

      _invalid_summary_post =
        Factory.insert(:post, user_jar_link_id: user_jar_link.id, updated_at: invalid_updated_at)

      valid_summary_post =
        Factory.insert(:post, user_jar_link_id: user_jar_link.id, updated_at: valid_updated_at)

      edge_summary_post =
        Factory.insert(:post, user_jar_link_id: user_jar_link.id, updated_at: edge_updated_at)

      _another_jar_summary_post =
        Factory.insert(:post,
          user_jar_link_id: another_user_jar_link.id,
          updated_at: valid_updated_at
        )

      assert Enum.count(Posts.get_recent_posts_for_jar(user_jar_link.jar_id)) == 2

      assert Posts.get_recent_posts_for_jar(user_jar_link.jar_id) == [
               valid_summary_post,
               edge_summary_post
             ]
    end
  end
end
