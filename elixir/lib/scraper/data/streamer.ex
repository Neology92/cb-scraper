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

    timestamps()
  end

  def changeset(streamer, params \\ %{}) do
    streamer
    |> cast(params, [:category, :path, :twitter, :instagram, :onlyfans, :misc])
    |> validate_required([:category, :path])
    |> validate_updated_at()
    |> unique_constraint(:path)
  end

  defp validate_updated_at(changeset) do
    time =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    force_change(changeset, :updated_at, time)
  end
end
