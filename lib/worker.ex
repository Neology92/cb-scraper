defmodule Scraper.Worker do
  use GenServer

  alias Scraper.Data

  # 5 minutes
  @new_streamers_interval 5 * 60 * 1000

  # 1 minute
  @contact_detail_interval 60 * 1000

  # Client
  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  # Server
  def init(_) do
    Process.send_after(self(), :new_streamers, 1000)
    schedule_scraping_contact_detail()
    schedule_collecting_streamers()
    {:ok, 1}
  end

  defp schedule_collecting_streamers do
    Process.send_after(self(), :new_streamers, @new_streamers_interval)
  end

  defp schedule_scraping_contact_detail do
    Process.send_after(self(), :contact, @contact_detail_interval)
  end

  def handle_info(:new_streamers, page) do
    categories = [
      "/female-cams/",
      "/male-cams/",
      "/couple-cams/",
      "/trans-cams/"
    ]

    for category <- categories do
      case Scraper.get_cams_paths_from(category <> "?page=" <> Integer.to_string(page)) do
        {:ok, paths} ->
          for path <- paths do
            case Scraper.Data.create_streamer(%{
                   category: category,
                   path: path
                 }) do
              {:ok, _} -> IO.puts("Added new streamer do DB: " <> path)
              {:error, _} -> nil
            end
          end

        {:error, reason} ->
          IO.warn("Something went wrong: " <> reason)
      end
    end

    IO.puts("Done collecting new streamers.")

    page = if page > 70, do: 1, else: page + 1
    schedule_collecting_streamers()
    {:noreply, page}
  end

  def handle_info(:contact, state) do
    streamer = Data.get_streamer_to_update()

    case Scraper.get_external_links_from(streamer.path) do
      {:ok, urls} ->
        urls
        |> IO.inspect()
        |> create_params(streamer)
        |> Data.update_streamer(streamer)

        IO.puts("Updated " <> streamer.path)

      {:error, reason} ->
        IO.warn("Something went wrong: " <> reason)
    end

    IO.puts("Done collecting contact detail.")

    schedule_scraping_contact_detail()
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
        Kernel.is_nil(acc.misc) -> %{acc | misc: url}
        true -> %{acc | misc: update_misc(acc.misc, url)}
      end
    end)
  end

  defp update_misc(misc, url) do
    (String.split(misc, ", ") ++ [url])
    |> Enum.uniq()
    |> Enum.join(", ")
  end
end
