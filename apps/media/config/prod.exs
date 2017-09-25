use Mix.Config

config :media, Media.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "media_sites",
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  hostname: System.get_env("DB_HOST")
