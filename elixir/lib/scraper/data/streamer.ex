defmodule Scraper.Data.Streamer do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast(params, [:category, :path, :twitter, :instagram, :onlyfans, :misc])
    |> validate_required([:category, :path])
    |> unique_constraint(:path)
  end
end
