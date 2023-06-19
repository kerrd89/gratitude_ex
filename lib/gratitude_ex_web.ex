defmodule GratitudeExWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use GratitudeExWeb, :controller
      use GratitudeExWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def static_paths do
    ~w(assets fonts images favicon.ico robots.txt)
  end

  def router do
    quote do
      use Phoenix.Router, helpers: true

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import GratitudeExWeb.Gettext
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        namespace: GratitudeExWeb,
        formats: [:html, :json],
        layouts: [html: GratitudeExWeb.Layouts]

      import Plug.Conn
      import GratitudeExWeb.Gettext

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {GratitudeExWeb.Layouts, :app},
        container: {:div, class: "contents"}

      # on_mount GratitudeExWeb.RestoreLocale

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      # on_mount GratitudeExWeb.RestoreLocale

      unquote(html_helpers())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      unquote(html_helpers())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: GratitudeExWeb.Endpoint,
        router: GratitudeExWeb.Router,
        statics: GratitudeExWeb.static_paths()
    end
  end

  defp html_helpers do
    quote do
      import Phoenix.HTML
      import Phoenix.HTML.Form
      import Phoenix.HTML.Link
      import Phoenix.HTML.Tag

      import GratitudeExWeb.Components.Buttons
      import GratitudeExWeb.Components.Headings
      import GratitudeExWeb.Components.Modals
      import GratitudeExWeb.Components.Form
      import GratitudeExWeb.CoreComponents

      import GratitudeExWeb.Gettext
      import GratitudeExWeb.FlashHelpers
      import GratitudeExWeb.ErrorHelpers

      alias Phoenix.LiveView.Js

      unquote(verified_routes())
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
