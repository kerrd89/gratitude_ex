defmodule GratitudeEx.JarsTest do
  use GratitudeEx.DataCase

  alias GratitudeEx.Jars
  alias GratitudeEx.Jars.Jar

  alias GratitudeEx.Factory

  @invalid_attrs %{title: nil}

  test "list_jars/0 returns all jars" do
    jar = Factory.insert(:jar)
    assert Jars.list_jars() == [jar]
  end

  test "get_jar!/1 returns the jar with given id" do
    jar = Factory.insert(:jar)
    assert Jars.get_jar!(jar.id) == jar
  end

  describe "create_jar_for_user/3" do
    setup _context do
      user = Factory.create_user()
      {:ok, user: user}
    end

    test "with valid data creates a jar", %{user: user} do
      valid_attrs = %{
        title: "some title",
        send_summary?: true,
        send_summary_method: :in_app,
        goal_entry_count: 3,
        goal_interval: :monthly
      }

      assert {:ok, %Jar{} = jar} = Jars.create_jar_for_user(%Jar{}, user.id, valid_attrs)
      assert jar.title == "some title"

      preloaded_jar = Jars.get_jar!(jar.id) |> GratitudeEx.Repo.preload(:user_jar_links)

      assert [user_jar_link] = preloaded_jar.user_jar_links
      assert user_jar_link.role == :admin
      assert user_jar_link.jar_id == jar.id
      assert user_jar_link.user_id == user.id
    end

    test "with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} =
               Jars.create_jar_for_user(%Jar{}, user.id, @invalid_attrs)
    end
  end

  test "update_jar/2 with valid data updates the jar" do
    jar = Factory.insert(:jar)
    update_attrs = %{title: "some updated title"}

    assert {:ok, %Jar{} = jar} = Jars.update_jar(jar, update_attrs)
    assert jar.title == "some updated title"
  end

  test "update_jar/2 with invalid data returns error changeset" do
    jar = Factory.insert(:jar)
    assert {:error, %Ecto.Changeset{}} = Jars.update_jar(jar, @invalid_attrs)
    assert jar == Jars.get_jar!(jar.id)
  end

  test "delete_jar/1 deletes the jar" do
    jar = Factory.insert(:jar)
    assert {:ok, %Jar{}} = Jars.delete_jar(jar)
    assert is_nil(Jars.get_jar!(jar.id))
  end

  test "change_jar/1 returns a jar changeset" do
    jar = Factory.insert(:jar)
    assert %Ecto.Changeset{} = Jars.change_jar(jar)
  end
end
