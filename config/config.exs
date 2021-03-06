# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :gravur,
  ecto_repos: [Gravur.Repo]

# Configures the endpoint
config :gravur, GravurWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BzfHXC2bmaJL9r1DNOcZn3xh5yn945IkFKBE3phJURNO/2Bdp9pJ7MEE06CuJMUZ",
  render_errors: [view: GravurWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Gravur.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :gravur, Gravur.Externals.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.gmail.com",
  port: 465,
  username: System.get_env("SMTP_USERNAME"),
  password: System.get_env("SMTP_PASSWORD"),
  tls: :if_available,
  ssl: true,
  retries: 1

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
