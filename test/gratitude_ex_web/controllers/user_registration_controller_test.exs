defmodule GratitudeExWeb.Controllers.UserRegistrationControllerTest do
  use GratitudeExWeb.ConnCase, async: true

  alias GratitudeEx.Factory

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, ~p"/users/register")
      response = html_response(conn, 200)
      assert response =~ "Create account"
      assert response =~ "Sign In"
    end

    test "redirects if already logged in", %{conn: conn} do
      user = Factory.create_user()
      conn = conn |> log_in_user(user) |> get(~p"/users/register")
      assert redirected_to(conn) == "/jars"
    end
  end

  describe "POST /users/register" do
    test "creates account and logs the user in", %{conn: conn} do
      email = Factory.unique_user_email()

      conn =
        post(conn, ~p"/users/register", %{
          "user" => Factory.valid_user_attributes(email: email)
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/jars"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/jars")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ "Settings"
      assert response =~ "Sign Out"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, ~p"/users/register", %{
          "user" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "Create account"

      assert response =~
               "Sorry there was an issue! Check the errors below and try registering again."

      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end
