defmodule GratitudeExWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use GratitudeExWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias GratitudeEx.Factory

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import GratitudeExWeb.ConnCase

      alias GratitudeExWeb.Router.Helpers, as: Routes

      use GratitudeExWeb, :verified_routes

      # The default endpoint for testing
      @endpoint GratitudeExWeb.Endpoint
    end
  end

  setup tags do
    GratitudeEx.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def register_and_log_in_user(%{conn: conn}, user \\ Factory.create_user()) do
    %{conn: log_in_user(conn, user), user: user}
  end

  def log_in_user(conn, user) do
    token = GratitudeEx.Auth.generate_user_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end
end
