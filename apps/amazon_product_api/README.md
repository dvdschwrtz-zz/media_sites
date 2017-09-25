# AmazonProductApi

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `amazon_product_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:amazon_product_api, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/amazon_product_api](https://hexdocs.pm/amazon_product_api).

## Starting the project
anytime you run this project, you will need phantomjs running on your computer.
once you have phantomjs installed, open a new terminal tab and enter in:
- phantomjs --wd

then, when you call this project initially, you need to run the following commands:

- mix deps.clean --all
- mix deps.get
- AWS_TAG={your_tag} AWS_KEY={your_key} mix deps.compile
- AWS_SECRET_KEY={your_secret_key} WEBDRIVER=phantomjs iex -S mix

after the first time, for subsequent calls of this project, you only need to run the following command:
- AWS_SECRET_KEY={your_secret_key} WEBDRIVER=phantomjs iex -S mix
