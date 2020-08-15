defmodule Scraper.Repo.Migrations.CreateStreamers do
  use Ecto.Migration

  def change do
    create table(:streamers) do
      add :path, :string, [:primary_key]
      add :category, :string
      add :twitter, :string
      add :instagram, :string
      add :onlyfans, :string
      add :misc, :string
    end

    create(unique_index(:streamers, [:path]))
  end
end
