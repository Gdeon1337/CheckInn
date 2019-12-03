# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :check_inn,
  ecto_repos: [CheckInn.Repo]

# Configures the endpoint
config :check_inn, CheckInnWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3nxNv2VP+qihb2rPKNSEY6l6uViAvxAs0SOaZnbAxPiEOOQfMjG3LrZ9dKgkw/Ns",
  render_errors: [view: CheckInnWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CheckInn.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :check_inn, CheckInnWeb.Plugs.Guardian,
  issuer: "check_inn",
  secret_key: "cm+X9nX8Mc6M98c+Uo/ZWctebdmwTHOM5nlAfdpi+qFEaGd2uoh6CdDWZRoCC2qW"


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
