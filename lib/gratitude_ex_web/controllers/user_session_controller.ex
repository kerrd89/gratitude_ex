defmodule GratitudeExWeb.UserSessionController do
  use GratitudeExWeb, :controller

  alias GratitudeEx.Auth
  alias GratitudeExWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/account")
    |> login(params)
  end

  def create(conn, params) do
    login(conn, params)
  end

  def login(conn, %{"user" => auth_params}) do
    %{"email" => email, "password" => password} = auth_params

    if user = Auth.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, auth_params)
    else
      conn
      |> put_flash(:error, "Invalid email or password")
      |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
