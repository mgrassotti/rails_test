class ApiClient
  class ApiConnectionError < StandardError; end

private
  def api_url
    Rails.configuration.external_api[:url]
  end

  def credentials
    Rails.application.credentials.widget_api
  end

  def access_token
    @access_token ||= get_new_access_token
  end

  def get_new_access_token
    response = HTTParty.post(
      api_url + "/oauth/token",
      body: {
        "grant_type": "password",
        "client_id": credentials[:client_id],
        "client_secret": credentials[:client_secret],
        "username": "michael1234@showoff.ie",
        "password": "password"
      }
    )
    if response.code == 200
      @access_token = response["data"]["access_token"]
      @refresh_token = response["data"]["refresh_token"]
    else
      raise ApiConnectionError, "#{response.code} - #{response.message}"
    end
  end

  def refresh_access_token
    response = HTTParty.post(
      api_url + "/oauth/token",
      body: {
        "grant_type": "refresh_token",
        "refresh_token": @refresh_token,
        "client_id": credentials[:client_id],
        "client_secret": credentials[:client_secret]
      }
    )
    if response.code == 200
      @access_token = response["data"]["access_token"]
      @refresh_token = response["data"]["refresh_token"]
    else
      raise ApiConnectionError, "#{response.code} - #{response.message}"
    end
  end
end
