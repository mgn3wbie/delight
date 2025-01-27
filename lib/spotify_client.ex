defmodule SpotifyClient do
  defp list_all_albums_as_json_for(artist_id, types, offset \\ 0) do
    auth_token = TokenHandler.get_auth_token()
    limit = 50

    url =
      "https://api.spotify.com/v1/artists/#{artist_id}/albums?limit=#{limit}&offset=#{offset}&include_groups=#{types}"

    headers = [{"Authorization", auth_token}]

    response = HTTPoison.get!(url, headers)

    if response.status_code == 200 do
      json_response = Jason.decode!(response.body)

      album_list_json =
        Enum.map(json_response["items"], fn item ->
          item
        end)

      # recursive call if more than max limit from api
      if length(album_list_json) == limit do
        album_list_json ++ list_all_albums_as_json_for(artist_id, types, offset + limit)
      else
        album_list_json
      end
    else
    end
  end

  def list_all_albums_for(artist_id, types \\ "album,single") do
    album_list_json = list_all_albums_as_json_for(artist_id, types)

    album_list =
      Enum.map(album_list_json, fn album ->
        album["name"]
      end)

    album_list
  end

  defp list_all_albums_from_date_for(artist_id, types, sort_order) do
    album_list_json = list_all_albums_as_json_for(artist_id, types)

    # convert json to tuples to ease comparison
    album_list_tuples =
      Enum.map(album_list_json, fn album ->
        {album["name"],
         case album["release_date_precision"] do
           "year" -> album["release_date"] <> "-01-01"
           "month" -> album["release_date"] <> "-01"
           "day" -> album["release_date"]
         end}
      end)

    # sort the wrong way since map will reverse the order for performance
    sorted_album_list_tuples =
      Enum.sort(
        album_list_tuples,
        &(Date.compare(
            Date.from_iso8601!(elem(&1, 1)),
            Date.from_iso8601!(elem(&2, 1))
          ) !=
            case sort_order do
              "asc" -> :gt
              "desc" -> :lt
            end)
      )

    # get album names
    sorted_album_list =
      Enum.map(sorted_album_list_tuples, fn album_tuple ->
        elem(album_tuple, 0)
      end)

    sorted_album_list
  end

  def list_all_albums_from_most_recent_for(artist_id, types \\ "album,single") do
    list_all_albums_from_date_for(artist_id, types, "desc")
  end
end
