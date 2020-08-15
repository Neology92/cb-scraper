defmodule Scraper do
  @base_url "https://chaturbate.com"
  @female_path "/female-cams/"

  def females_url do
    @base_url <> @female_path
  end

  def cam_url(path) do
    @base_url <> path
  end

  def get_cams_paths_from(path) do
    case HTTPoison.get(@base_url <> path) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Floki.find("#room_list > li")
        |> Floki.find(".details > .title > a")
        |> Floki.attribute("href")

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  def get_external_links_from(path) do
    case HTTPoison.get(@base_url <> path) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Floki.parse_document!()
        |> Floki.find("a")
        |> Floki.attribute("href")
        |> Enum.filter(fn path -> String.match?(path, ~r/external_link/) end)
        |> Enum.map(fn path -> decode(path) end)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  defp decode(path) do
    path
    |> String.replace("/external_link/?url=", "")
    |> URI.decode()
  end
end
