defmodule GratitudeExWeb.UserResetPasswordController do
  use GratitudeExWeb, :controller

  alias GratitudeEx.Auth
  alias GratitudeEx.Repo

  plug :get_credentials_by_reset_password_token when action in [:edit, :update]

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"credentials" => %{"email" => email}}) do
    if credentials = Auth.get_creds_by_email(email) do
      Auth.deliver_user_reset_password_instructions(
        credentials,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    conn
    |> put_flash(
      :info,
      gettext(
        "If your email is associated with an account an email will be sent to reset your password."
      )
    )
    |> redirect(to: ~p"/")
  end

  def edit(conn, _params) do
    render(conn, :edit, changeset: Auth.change_user_password(conn.assigns.credentials))
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def update(conn, %{"credentials" => user_params}) do
    credentials = Repo.preload(conn.assigns.credentials, [:user, :installer])

    case Auth.reset_user_password(credentials, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Password reset successfully.")
        |> redirect(to: ~p"/users/login")

      {:error, changeset} ->
        render(conn, :edit, changeset: changeset)
    end
  end

  defp get_credentials_by_reset_password_token(conn, _opts) do
    %{"token" => token} = conn.params

    if credentials = Auth.get_credentials_by_reset_password_token(token) do
      conn |> assign(:credentials, credentials) |> assign(:token, token)
    else
      conn
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
