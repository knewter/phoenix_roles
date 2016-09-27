use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_roles, PhoenixRoles.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenix_roles, PhoenixRoles.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "phoenix_roles_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
