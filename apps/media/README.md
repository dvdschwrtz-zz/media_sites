# Media

Always run this project with a MEDIA_ENV variable set to a site that has been built out.
For example: "MEDIA_ENV=10devices mix phoenix.server" or "MEDIA_ENV=10devices mix test"

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `media` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:media, "~> 0.1.0"}]
    end
    ```

  2. Ensure `media` is started before your application:

    ```elixir
    def application do
      [applications: [:media]]
    end
    ```
