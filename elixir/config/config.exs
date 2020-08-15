use Mix.Config

config :scraper, Scraper.Repo,
  database: "scraper_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :scraper,
  ecto_repos: [Scraper.Repo]
