FROM elixir:1.4.2
COPY . /usr/src
WORKDIR /usr/src/apps/media_web
RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get --only prod \
    && MIX_ENV=prod mix compile \
    && MIX_ENV=prod mix phoenix.digest

EXPOSE 4000
