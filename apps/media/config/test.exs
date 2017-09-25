use Mix.Config

config :media, Media.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "media_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
