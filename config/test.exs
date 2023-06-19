import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :gratitude_ex, GratitudeEx.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "gratitude_ex_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gratitude_ex, GratitudeExWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "L5+eBF38BgtE9TbQOzHDpc6nJIVVNoCrZEm8mmyRINIcrv83KATMYPDbVbsVphTt",
  server: false

# In test we don't send emails.
config :gratitude_ex, GratitudeEx.Mailer, adapter: Swoosh.Adapters.Test

# In test we want manual mode
config :gratitude_ex, Oban, testing: :inline

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
