defmodule Gravur.Repo do
  use Ecto.Repo,
    otp_app: :gravur,
    adapter: Ecto.Adapters.Postgres
end
