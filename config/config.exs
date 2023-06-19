# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :gratitude_ex,
  namespace: GratitudeEx,
  ecto_repos: [GratitudeEx.Repo],
  env: Mix.env()

# Configures the endpoint
config :gratitude_ex, GratitudeExWeb.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  url: [host: "localhost"],
  render_errors: [
    view: GratitudeExWeb.ErrorView,
    accepts: ~w(html json),
    layout: false
  ],
  pubsub_server: GratitudeEx.PubSub,
  render_errors: [
    formats: [html: GratitudeExWeb.ErrorHTML, json: GratitudeExWeb.ErrorJSON],
    layout: false
  ],
  # pubsub_server: GratitudeEx.PubSub,
  live_view: [signing_salt: "2arGAxop"]

# Configure localization
config :ex_cldr, :default_backend, GratitudeEx.Cldr
config :gettext, :default_locale, :en

# Configure Oban
config :gratitude_ex, Oban,
  repo: GratitudeEx.Repo,
  plugins: [
    {Oban.Plugins.Pruner, max_age: 60 * 60 * 24},
    {Oban.Plugins.Cron, crontab: [
      {"@daily", GratitudeEx.Jobs.Notifications.SendJarSummaries, args: %{starting_jar_id: 1}}
    ]}
  ],
  queues: [default: 10]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :gratitude_ex, GratitudeEx.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
    --config=tailwind.config.js
    --input=css/app.css
    --output=../priv/static/assets/app.css
  ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
