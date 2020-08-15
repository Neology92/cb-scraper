defmodule Scraper.Loops do
  alias Scraper

  def get_externals_from_page_1 do
    links =
      Scraper.get_cams_paths_from("/female-cams/")
      |> Enum.map(fn path -> Scraper.get_external_links_from(path) end)

    {:ok, file} = File.open("results/links.txt", [:write])
    IO.binwrite(file, links)
    File.close(file)
  end
end
