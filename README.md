# CB Scraper
Easy contact data collecting on chaturbate streamers

## First steps

1. Install postgresql
2. Setup config.exs:
  - username: <your_postgres_username>,
  - password: <your_postgres_password>,

4. Go to app folder in terminal and run:
```
$ mix deps.get
```

5. Create and migrate db
```
$ mix ecto.create
$ mix ecto.migrate
```

6. Start app
```
$ iex -S mix
```
