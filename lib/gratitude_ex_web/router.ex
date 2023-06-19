defmodule GratitudeExWeb.Router do
  use GratitudeExWeb, :router

  import GratitudeExWeb.UserAuth,
    only: [
      fetch_current_user: 2,
      redirect_if_user_is_authenticated: 2,
      require_authenticated_user: 2
    ]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GratitudeExWeb.Layouts, :root}
    plug :protect_from_forgery

    plug :put_secure_browser_headers,
         %{
           # https://content-security-policy.com/
           # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy
           # "content-security-policy" => "default-src 'self'; object-src 'none'; img-src 'self' blob:;"
           "x-frame-options" => "SAMEORIGIN",
           "referrer-policy" =>
             "no-referrer | same-origin | origin | strict-origin | no-origin-when-downgrading",
           "x-content-type-options" => "nosniff",
           "x-permitted-cross-domain-policies" => "none"
         }

    plug :fetch_current_user
    plug GratitudeExWeb.Plugs.AssignDebugInfo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :unauthenticated_layout do
    plug :put_layout, html: {GratitudeExWeb.Layouts, :unauthenticated}
  end

  ## Authentication routes
  scope "/", GratitudeExWeb do
    pipe_through [:browser, :unauthenticated_layout, :redirect_if_user_is_authenticated]

    get "/", PageController, :index

    get "/users/login", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create

    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", GratitudeExWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
  end

  scope "/", GratitudeExWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :users,
      on_mount: [
        GratitudeExWeb.Hooks.AllowEctoSandbox,
        GratitudeExWeb.Hooks.LocalNavHook,
        {GratitudeExWeb.Hooks.UserLiveAuthHook, :default},
        GratitudeExWeb.Hooks.DebugInfoHook
      ] do
      live "/account", AccountLive.Edit
      # live "/account/change_password", AccountLive.ChangePassword
      live "/jars", JarsLive.Index, :index
      live "/notifications", NotificationsLive.Index, :index
      live "/jars/new", JarsLive.New, :new
      live "/jars/:jar_id", JarsLive.Show, :show
      live "/jars/:jar_id/edit", JarsLive.Edit, :edit
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GratitudeExWeb.Telemetry
    end
  end
end
