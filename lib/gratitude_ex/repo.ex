defmodule GratitudeEx.Repo do
  use Ecto.Repo,
    otp_app: :gratitude_ex,
    adapter: Ecto.Adapters.Postgres
end
