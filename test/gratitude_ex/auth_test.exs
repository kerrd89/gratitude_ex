defmodule GratitudeEx.AuthTest do
  use GratitudeEx.DataCase, async: true

  alias GratitudeEx.Auth

  alias GratitudeEx.Auth.{User, UserToken}
  alias GratitudeEx.Repo
  alias GratitudeEx.Factory

  describe "get_user_by_email/1" do
    test "does not return the user if the email does not exist" do
      refute Auth.get_user_by_email("unknown@example.com")
    end

    test "returns the user if the email exists" do
      %{id: id} = user = Factory.create_user()
      assert %User{id: ^id} = Auth.get_user_by_email(user.email)
    end
  end

  describe "get_user_by_email_and_password/2" do
    test "does not return the user if the email does not exist" do
      refute Auth.get_user_by_email_and_password("unknown@example.com", "hello world!")
    end

    test "does not return the user if the password is not valid" do
      user = Factory.create_user()
      refute Auth.get_user_by_email_and_password(user.email, "invalid")
    end

    test "returns the user if the email and password are valid" do
      %{id: id} = user = Factory.create_user()

      assert %User{id: ^id} =
               Auth.get_user_by_email_and_password(user.email, Factory.valid_user_password())
    end
  end

  describe "get_user!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Auth.get_user!(-1)
      end
    end

    test "returns the user with the given id" do
      %{id: id} = user = Factory.create_user()
      assert %User{id: ^id} = Auth.get_user!(user.id)
    end
  end

  describe "register_user/1" do
    test "requires email and password to be set" do
      {:error, changeset} = Auth.register_user(%{})

      assert %{
               password: ["can't be blank"],
               email: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates email and password when given" do
      {:error, changeset} = Auth.register_user(%{email: "not valid", password: "not valid"})

      assert %{
               email: ["must have the @ sign and no spaces"],
               password: ["should be at least 12 character(s)"]
             } = errors_on(changeset)
    end

    test "validates maximum values for email and password for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Auth.register_user(%{email: too_long, password: too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).email
      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "validates email uniqueness" do
      %{email: email} = Factory.create_user()
      {:error, changeset} = Auth.register_user(%{email: email})
      assert "has already been taken" in errors_on(changeset).email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} = Auth.register_user(%{email: String.upcase(email)})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "registers users with a hashed password and generates welcome notification" do
      email = Factory.unique_user_email()

      Oban.Testing.with_testing_mode(:manual, fn ->
        {:ok, user} = Auth.register_user(Factory.valid_user_attributes(email: email))
        assert user.email == email
        assert is_binary(user.hashed_password)
        assert is_nil(user.password)

        assert_enqueued(
          worker: GratitudeEx.Events.UserCreated,
          args: %{"user_id" => user.id}
        )
      end)
    end
  end

  describe "change_user_registration/2" do
    test "returns a changeset" do
      assert %Ecto.Changeset{} = changeset = Auth.change_user_registration(%User{})
      assert changeset.required == [:password, :email]
    end

    test "allows fields to be set" do
      email = Factory.unique_user_email()
      password = Factory.valid_user_password()

      changeset =
        Auth.change_user_registration(
          %User{},
          Factory.valid_user_attributes(email: email, password: password)
        )

      assert changeset.valid?
      assert get_change(changeset, :email) == email
      assert get_change(changeset, :password) == password
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "change_user_password/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Auth.change_user_password(%User{})
      assert changeset.required == [:password]
    end

    test "allows fields to be set" do
      changeset =
        Auth.change_user_password(%User{}, %{
          "password" => "new valid password"
        })

      assert changeset.valid?
      assert get_change(changeset, :password) == "new valid password"
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "update_user_password/3" do
    setup do
      %{user: Factory.create_user()}
    end

    test "validates password", %{user: user} do
      {:error, changeset} =
        Auth.update_user_password(user, Factory.valid_user_password(), %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 12 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{user: user} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Auth.update_user_password(user, Factory.valid_user_password(), %{password: too_long})

      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "validates current password", %{user: user} do
      {:error, changeset} =
        Auth.update_user_password(user, "invalid", %{password: Factory.valid_user_password()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "updates the password", %{user: user} do
      {:ok, user} =
        Auth.update_user_password(user, Factory.valid_user_password(), %{
          password: "new valid password"
        })

      assert is_nil(user.password)
      assert Auth.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "deletes all tokens for the given user", %{user: user} do
      _ = Auth.generate_user_session_token(user)

      {:ok, _} =
        Auth.update_user_password(user, Factory.valid_user_password(), %{
          password: "new valid password"
        })

      refute Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "generate_user_session_token/1" do
    setup do
      %{user: Factory.create_user()}
    end

    test "generates a token", %{user: user} do
      token = Auth.generate_user_session_token(user)
      assert user_token = Repo.get_by(UserToken, token: token)
      assert user_token.context == "session"

      # Creating the same token for another user should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%UserToken{
          token: user_token.token,
          user_id: Factory.create_user().id,
          context: "session"
        })
      end
    end
  end

  describe "get_user_by_session_token/1" do
    setup do
      user = Factory.create_user()
      token = Auth.generate_user_session_token(user)
      %{user: user, token: token}
    end

    test "returns user by token", %{user: user, token: token} do
      assert session_user = Auth.get_user_by_session_token(token)
      assert session_user.id == user.id
    end

    test "does not return user for invalid token" do
      refute Auth.get_user_by_session_token("oops")
    end

    test "does not return user for expired token", %{token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Auth.get_user_by_session_token(token)
    end
  end

  describe "delete_session_token/1" do
    test "deletes the token" do
      user = Factory.create_user()
      token = Auth.generate_user_session_token(user)
      assert Auth.delete_session_token(token) == :ok
      refute Auth.get_user_by_session_token(token)
    end
  end

  describe "inspect/2" do
    test "does not include password" do
      refute inspect(%User{password: "123456"}) =~ "password: \"123456\""
    end
  end
end
