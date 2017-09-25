use Mix.Config

config :amazon_product_api, AmazonProductApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "amazon_product_api_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :amazon_product_api, ecto_repos: [AmazonProductApi.Repo]

config :amazon_product_advertising_client,
  associate_tag: "#{System.get_env("AWS_TAG")}",
  aws_access_key_id: "#{System.get_env("AWS_KEY")}",
  aws_secret_access_key: "#{System.get_env("AWS_SECRET_KEY")}"
