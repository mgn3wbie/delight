FROM elixir:1.18-alpine

WORKDIR /app

COPY mix.exs mix.lock ./

RUN mix deps.get

COPY . .

RUN mix compile

CMD ["iex", "-S", "mix"]