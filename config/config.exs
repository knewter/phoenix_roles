# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_roles,
  ecto_repos: [PhoenixRoles.Repo]

# Configures the endpoint
config :phoenix_roles, PhoenixRoles.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2uKKUxWFB1BpnHuig2XDHhXgVm0NyGWpfUV8EFYMiq0JkcVzGGd2HvfnVvewBTkz",
  render_errors: [view: PhoenixRoles.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixRoles.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: PhoenixRoles.User,
  repo: PhoenixRoles.Repo,
  module: PhoenixRoles,
  logged_out_url: "/",
  email_from: {"Josh Adams", "josh@dailydrip.com"},
  opts: [:rememberable, :authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :invitable, :registerable]

config :coherence, PhoenixRoles.Coherence.Mailer,
  adapter: Swoosh.Adapters.Mailgun,
  api_key: System.get_env("MAILGUN_API_KEY"),
  domain: System.get_env("MAILGUN_DOMAIN")
# %% End Coherence Configuration %%

config :phoenix_integration,
  endpoint: PhoenixRoles.Endpoint

config :policy_wonk, PolicyWonk,
  policies: PhoenixRoles.Policies

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
