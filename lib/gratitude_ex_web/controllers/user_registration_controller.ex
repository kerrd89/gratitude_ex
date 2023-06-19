defmodule GratitudeExWeb.UserRegistrationController do
  use GratitudeExWeb, :controller

  alias GratitudeEx.Auth
  alias GratitudeEx.Auth.User
  alias GratitudeExWeb.UserAuth

  def new(conn, _params) do
    changeset = Auth.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Auth.register_user(user_params) do
      {:ok, %User{} = user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(
          :error,
          "Sorry there was an issue! Check the errors below and try registering again."
        )
        |> render("new.html", changeset: changeset)
    end
  end
end
