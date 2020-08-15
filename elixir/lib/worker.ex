defmodule Scraper.Worker do
  use GenServer

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

    {:noreply, state}
  end

  def handle_cast(:contact, state) do
    Scraper.get_external_links_from("")
    {:noreply, state}
  end
end
