defmodule Scraper.Repo.Migrations.CreateStreamers do
  use Ecto.Migration

  def change do
    create table(:streamers) do
      add :category, :string
      add :path, :string
      add :twitter, :string
      add :instagram, :string
      add :onlyfans, :string
      add :misc, :string
    end
  end
end
