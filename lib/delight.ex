defmodule Delight do
  @moduledoc """
  Documentation for `Delight`.
  """

  defp orelsan do
    "4FpJcNgOvIpSBeJgRg3OfN"
  end

  def list_albums do
    SpotifyClient.list_all_albums_for(orelsan())
  end

  def list_albums_without_singles do
    SpotifyClient.list_all_albums_for(orelsan(), "album")
  end

  def list_albums_sorted_by_date do
    SpotifyClient.list_all_albums_from_most_recent_for(orelsan())
  end

  def main do
    list_all = list_albums()
    list_without_singles = list_albums_without_singles()
    list_sorted_by_date = list_albums_sorted_by_date()

    [
      {"result of list_albums() :", list_all},
      {"result of list_albums_without_singles() :", list_without_singles},
      {"result of list_albums_sorted_by_date() :", list_sorted_by_date}
    ]
  end
end
