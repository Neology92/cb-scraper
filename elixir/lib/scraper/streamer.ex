defmodule Scraper.Streamer do
  use Ecto.Schema

  schema "streamers" do
    field :category, :string
    field :path, :string
    field :twitter, :string
    field :instagram, :string
    field :onlyfans, :string
    field :misc, :string
  end

  def changeset(streamer, params \\ %{}) do
    streamer
    |> Ecto.Changeset.cast(params, [:category, :path, :twitter, :instagram, :onlyfans, :misc])
    |> Ecto.Changeset.validate_required([:category, :path])
  end
end
