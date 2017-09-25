use Mix.Config

config :media, Media.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "media_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
