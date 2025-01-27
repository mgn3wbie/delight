defmodule TokenHandler do
  defp table do
    :token_holder
  end

  # todo : parameterize the credentials
  defp fetch_auth_token do
    url = "https://accounts.spotify.com/api/token"
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    client_id = System.get_env("CLIENT_ID")
    client_secret = System.get_env("CLIENT_SECRET")
    body = "grant_type=client_credentials&client_id=#{client_id}&client_secret=#{client_secret}"

    response = HTTPoison.post!(url, body, headers)

    if response.status_code == 200 do
      json_response = Jason.decode!(response.body)
      token = json_response["access_token"]
      token_type = json_response["token_type"]
      expires_in = json_response["expires_in"]
      expiration_date = NaiveDateTime.add(NaiveDateTime.utc_now(), expires_in)
      set_token(token, token_type, expiration_date)
    else
      IO.inspect("ERROR IN FETCH_AUTH_TOKEN")
      IO.inspect(response)
    end
  end

  defp set_token(token, token_type, expiration_date) do
    ETSManager.set_key_value_pair_in_table(:token, token, table())
    ETSManager.set_key_value_pair_in_table(:token_type, token_type, table())
    ETSManager.set_key_value_pair_in_table(:expiration_date, expiration_date, table())
  end

  defp is_token_valid_in(min_span) do
    expiration_date = ETSManager.get_value_for_key_in_table(:expiration_date, table())

    if expiration_date == :empty do
      false
    else
      date_being_tested = NaiveDateTime.add(NaiveDateTime.utc_now(), min_span * 60)
      NaiveDateTime.compare(date_being_tested, expiration_date) == :lt
    end
  end

  def get_auth_token do
    ETSManager.create_table_if_needed(table())

    if not is_token_valid_in(2) do
      fetch_auth_token()
    end

    "#{ETSManager.get_value_for_key_in_table(:token_type, table())} #{ETSManager.get_value_for_key_in_table(:token, table())}"
  end
end
