defmodule Scraper.Data do
  alias Scraper.Repo
  alias Scraper.Data.Streamer
  import Ecto.Query

  def get_streamer(path) do
    Repo.get_by(Streamer, path: path)
  end

  def get_streamer_to_update() do
    Streamer
    |> order_by(asc: :updated_at)
    |> first()
    |> Repo.one()
  end

  def list_streamers do
    Repo.all(Streamer)
  end

  def create_streamer(params) do
    Streamer.changeset(%Streamer{}, params)
    |> Repo.insert()
  end

  def update_streamer(streamer, params) do
    streamer
    |> Streamer.changeset(params)
    |> Repo.update()
  end

  def delete_streamer(streamer) do
    Repo.delete(streamer)
  end
end
