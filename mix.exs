defmodule GratitudeEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :gratitude_ex,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      compileers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      # releases: releases(),
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit],
        ignore_warnings: ".dialyzer_ignore.exs",
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        check_plt: true
      ],
      preferred_cli_env: [end_to_end: :test]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {GratitudeEx.Application, []},
      extra_applications: [:credo, :logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bandit, "~> 0.6"},
      {:bcrypt_elixir, "~> 3.0"},
      # phoenix_live_dashboard metrics_history
      # {:circular_buffer, "~> 0.4"},
      {:credo, "~> 1.7", runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:ecto, "~> 3.10"},
      # phoenix_live_dashboard ecto_stats
      {:ecto_psql_extras, "~> 0.7"},
      {:ecto_sql, "~> 3.10"},
      {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
      {:ex_aws, "~> 2.4"},
      {:ex_aws_s3, "~> 2.4"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:ex_cldr, "~> 2.33"},
      {:ex_cldr_dates_times, "~> 2.0"},
      {:ex_cldr_numbers, "~> 2.0"},
      {:ex_cldr_plugs, "~> 1.2"},
      {:ex_cldr_units, "~> 3.0"},
      {:ex_machina, "~> 2.7.0"},
      {:excellent_migrations, "~> 0.1", only: [:dev, :test], runtime: false},
      {:finch, "~> 0.13"},
      {:faker, "~> 0.17"},
      {:floki, ">= 0.30.0", only: [:dev, :test]},
      {:geocoder, "~> 1.1"},
      {:gettext, "~> 0.20"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:joken, "~> 2.6"},
      {:jose, "~> 1.11"},
      {:libcluster, "~> 3.3"},
      {:number, "~> 1.0"},
      {:observer_cli, "~> 1.7"},
      {:ostara, "~> 0.4"},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},
      # background jobs
      {:oban, "~> 2.17"},
      # {:oban_pro, "~> 0.13", repo: "oban"},
      # {:oban_web, "~> 2.9", repo: "oban"},
      {:phoenix, "~> 1.7"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_dashboard, "~> 0.8"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.19"},
      {:phoenix_view, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:recon, "~> 2.5"},
      {:sentry, "~> 8.0"},
      {:sobelow, "~> 0.11", only: [:dev, :test], runtime: false},
      # property testing
      {:stream_data, "~> 0.5"},
      {:sweet_xml, "~> 0.7"},
      {:swoosh, "~> 1.3"},
      # see https://hexdocs.pm/swoosh/Swoosh.Adapters.AmazonSES.html
      # {:gen_smtp, "~> 1.0"},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      # {:timescale, "~> 0.1"},
      {:tz, "~> 0.22"},
      {:tz_extra, "~> 0.22"},
      {:mox, "~> 1.0", only: :test},
      {:nx, "~> 0.4", github: "elixir-nx/nx", sparse: "nx", override: true},
      {:nimble_csv, "~> 1.1"},
      # {:wallaby, "~> 0.30", runtime: false, only: :test},
      {:x509, "~> 0.8"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"],
      check: [
        "format --check-formatted",
        "compile --force --warnings-as-errors",
        "credo",
        "dialyzer"
      ],
      "phx.routes": "phx.routes GratitudeExWeb.Router"
    ]
  end
end
