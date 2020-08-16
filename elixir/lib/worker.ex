defmodule Scraper.Worker do
  use GenServer

  alias Scraper.Data

  # client

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def check_new_streamers() do
    GenServer.cast(__MODULE__, :new_streamers)
  end

  def scrap_next_contact() do
    GenServer.cast(__MODULE__, :contact)
  end

  # server

  def init(_) do
    {:ok, []}
  end

  def handle_cast(:new_streamers, state) do
    categories = [
      "/female-cams/",
      "/male-cams/",
      "/couple-cams/",
      "/trans-cams/"
    ]

    for category <- categories do
      paths = Scraper.get_cams_paths_from(category)

      for path <- paths do
        case Scraper.Data.create_streamer(%{
               category: category,
               path: path
             }) do
          {:ok, _} -> IO.puts("Added new streamer do DB: " <> path)
          {:error, _} -> nil
        end
      end
    end

    IO.puts("Done collecting new streamers.")

    {:noreply, state}
  end

  def handle_cast(:contact, state) do
    streamer = Data.get_streamer_to_update()

    case Scraper.get_external_links_from(streamer.path) do
      {:ok, urls} ->
        urls
        |> create_params(streamer)
        |> Data.update_streamer(streamer)

        IO.puts("Updated " <> streamer.path)

      {:error, reason} ->
        IO.warn("Something went wrong: " <> reason)
    end

    IO.puts("Done collecting contact detail.")

    {:noreply, state}
  end

  defp create_params(urls, streamer) do
    acc = %{
      twitter: streamer.twitter,
      instagram: streamer.instagram,
      onlyfans: streamer.onlyfans,
      misc: streamer.misc
    }

    Enum.reduce(urls, acc, fn url, acc ->
      cond do
        String.match?(url, ~r/t.co/) -> %{acc | twitter: url}
        String.match?(url, ~r/twitter.com/) -> %{acc | twitter: url}
        String.match?(url, ~r/instagram.com/) -> %{acc | instagram: url}
        String.match?(url, ~r/onlyfans.com/) -> %{acc | onlyfans: url}
        true -> %{acc | misc: acc.misc <> ", " <> url}
      end
    end)
  end
end
