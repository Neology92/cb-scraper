use Mix.Config

config :scraper, Scraper.Repo,
  database: "scraper_repo",
  username: "postgres",
  password: "1234",
  hostname: "localhost",
  log: false

config :scraper,
  ecto_repos: [Scraper.Repo]
