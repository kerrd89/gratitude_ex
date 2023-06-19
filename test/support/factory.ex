defmodule GratitudeEx.Factory do
  @moduledoc "factories for creating things"
  use ExMachina.Ecto, repo: GratitudeEx.Repo

  def jar_factory do
    %GratitudeEx.Jars.Jar{
      title: random_string(),
      goal_entry_count: Enum.random(1..5)
    }
  end

  def post_factory do
    %GratitudeEx.Posts.Post{
      text: Faker.Lorem.Shakespeare.as_you_like_it()
    }
  end

  def quote_factory do
    %GratitudeEx.Quotes.Quote{
      text: Faker.Lorem.Shakespeare.as_you_like_it(),
      author: "Joe Schmoe"
    }
  end

  def notification_factory do
    %GratitudeEx.Notifications.Notification{
      message: Faker.Lorem.Shakespeare.as_you_like_it(),
      type: :summary
    }
  end

  def user_factory do
    %GratitudeEx.Auth.User{
      email: unique_user_email()
    }
  end

  def user_jar_link_factory do
    %GratitudeEx.Jars.UserJarLink{
      role: random_user_jar_link_role()
    }
  end

  def create_user(params \\ %{}) do
    valid_user_attrs = valid_user_attributes(params)
    {:ok, user} = GratitudeEx.Auth.register_user(valid_user_attrs, false)
    user
  end

  def valid_user_attributes(given_attrs \\ %{}) do
    given_attrs
    |> Enum.into(%{})
    |> Map.put_new_lazy(:email, &unique_user_email/0)
    |> Map.put_new_lazy(:password, &valid_user_password/0)
  end

  def random_string() do
    Ecto.UUID.generate()
    |> String.replace("-", "")
  end

  def unique_positive_integer, do: System.unique_integer([:positive])
  def unique_user_email, do: "user#{unique_positive_integer()}@example.com"
  def valid_user_password, do: "hello world!"
  def random_user_jar_link_role, do: Enum.random([:admin, :read, :write])
end
