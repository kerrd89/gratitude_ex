defmodule GratitudeEx.Jars do
  @moduledoc """
  The Jars context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias GratitudeEx.Repo

  alias GratitudeEx.Jars.{Jar, UserJarLink}
  alias GratitudeEx.Posts.Post
  alias GratitudeEx.Auth.User

  def list_jars do
    Repo.all(Jar)
  end

  def get_jar!(jar_id, _opts \\ []) do
    query =
      from j in Jar,
        where: j.id == ^jar_id

    Repo.one(query)
  end

  def create_jar_for_user(jar, user_id, attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:jar, fn _ -> Jar.changeset(jar, attrs) end)
    |> Multi.insert(:user_jar_link, fn %{jar: jar} ->
      UserJarLink.changeset(%UserJarLink{user_id: user_id, jar_id: jar.id}, %{role: :admin})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{jar: jar, user_jar_link: _user_jar_link}} ->
        {:ok, jar}

      {:error, :jar, changeset, _} ->
        {:error, changeset}
    end
  end

  def update_jar(%Jar{} = jar, attrs) do
    jar
    |> Jar.changeset(attrs)
    |> Repo.update()
  end

  def delete_jar(%Jar{} = jar) do
    Repo.delete(jar)
  end

  def change_jar(%Jar{} = jar, attrs \\ %{}) do
    Jar.changeset(jar, attrs)
  end

  def authorized?(%User{id: user_id}, %Jar{id: jar_id}) do
    not is_nil(get_user_jar_link_by_user_and_jar(user_id, jar_id))
  end

  def authorized?(_user, _jar), do: false

  def get_user_jar_link_by_user_and_jar(user_id, jar_id) do
    query =
      from usj in UserJarLink,
        where: usj.user_id == ^user_id,
        where: usj.jar_id == ^jar_id

    GratitudeEx.Repo.one(query)
  end

  def calculate_jar_goal_score(%Jar{goal_entry_count: goal_entry_count}, %UserJarLink{
        id: user_jar_link_id
      }) do
    today = NaiveDateTime.utc_now()
    one_week_in_seconds = 60 * 60 * 24 * 7
    one_week_ago = NaiveDateTime.add(today, -one_week_in_seconds)

    recent_posts =
      Repo.all(
        from p in Post,
          where: p.user_jar_link_id == ^user_jar_link_id,
          where: p.inserted_at >= ^one_week_ago,
          order_by: [desc: p.inserted_at],
          limit: ^goal_entry_count
      )

    length(recent_posts) / goal_entry_count
  end

  def get_all_jars_for_summaries() do
    # TODO: optimize this query
    query = from j in Jar,
    where: j.send_summary?,
    preload: [:notifications]

    Repo.all(query)
  end
end
