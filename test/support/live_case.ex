defmodule GratitudeExWeb.LiveCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require LiveView.

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

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest, except: [put_flash: 3]
      import Phoenix.LiveViewTest
      import GratitudeExWeb.ConnCase
      import GratitudeExWeb.LiveCase
      use GratitudeExWeb, :verified_routes

      # The default endpoint for testing
      @endpoint GratitudeExWeb.Endpoint
    end
  end

  setup tags do
    GratitudeEx.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @element_appearance_check_ms 25

  @doc """
  Assert that the given element selector can be found on the LiveView
  within the given number of milliseconds. Checks periodically so that if the
  element appears sooner, the test does not need to wait the full amount of
  time.

     assert element_appears_within_ms(my_view, "p#foo", 2_000)
  """
  def element_appears_within_ms(_live_view, _element_selector, ms) when ms <= 0 do
    false
  end

  def element_appears_within_ms(live_view, element_selector, ms) do
    present? =
      live_view
      |> Phoenix.LiveViewTest.element(element_selector)
      |> Phoenix.LiveViewTest.has_element?()

    if present? do
      true
    else
      Process.sleep(@element_appearance_check_ms)
      element_appears_within_ms(live_view, element_selector, ms - @element_appearance_check_ms)
    end
  end

  @doc """
  Same as `assert_element_appears_within_ms/3`, but with an additional "filter"
  argument.

     assert element_appears_within_ms(my_view, "p#foo", "some text", 2_000)
  """
  def element_appears_within_ms(_live_view, _element_selector, _filter, ms) when ms <= 0 do
    false
  end

  def element_appears_within_ms(live_view, element_selector, filter, ms) do
    present? =
      live_view
      |> Phoenix.LiveViewTest.element(element_selector, filter)
      |> Phoenix.LiveViewTest.has_element?()

    if present? do
      true
    else
      Process.sleep(@element_appearance_check_ms)

      element_appears_within_ms(
        live_view,
        element_selector,
        filter,
        ms - @element_appearance_check_ms
      )
    end
  end
end
