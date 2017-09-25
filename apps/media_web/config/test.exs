use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :media_web, MediaWeb.Endpoint,
  http: [port: 4001],
  server: false

config :media_web, ecto_repos: []

# Print only warnings and errors during test
config :logger, level: :warn
