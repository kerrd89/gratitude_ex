defmodule GratitudeEx.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query
  alias GratitudeEx.Repo

  alias GratitudeEx.Posts.Post

  @recent_window_for_summaries {:months, -1}

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> post = %Post{}
      iex> create_post(post, %{field: value})
      {:ok, %Post{}}

      iex> post = %Post{}
      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(post, attrs \\ %{}) do
    post
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def get_recent_posts_for_jar(jar_id, %DateTime{} = since \\ default_recent_date()) do
    query = from p in Post,
      where: p.updated_at >= ^since,
      join: ujl in assoc(p, :user_jar_link),
      where: ujl.jar_id == ^jar_id,
      select: p

    Repo.all(query)
  end

  def summarize_posts(posts) do
    Enum.reduce(posts, "", fn post, acc ->
      acc <> "\n" <> post.text
    end)
  end

  def default_recent_date do
    {unit, shift} = @recent_window_for_summaries
    Date.utc_today()
    |> Cldr.Calendar.plus(unit, shift)
    |> DateTime.new!(Time.utc_now())
  end
end
