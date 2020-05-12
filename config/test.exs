use Mix.Config

config :gravur,
  local_storage: true

# Configure your database
config :gravur, Gravur.Repo,
  username: "postgres",
  password: "postgres",
  database: "gravur_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gravur, GravurWeb.Endpoint,
  http: [port: 4002],
  server: false

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: "eu-west-1",
  s3: [
    scheme: "https://",
    host: "s3.eu-west-1.amazonaws.com",
    region: "eu-west-1"
  ]

# Print only warnings and errors during test
config :logger, level: :warn
