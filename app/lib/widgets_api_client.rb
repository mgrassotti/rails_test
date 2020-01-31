class WidgetsApiClient < ApiClient
  def self.all
    self.new.all
  end

  def all
    api_request :get, root_url, params, 'widgets'
  end

private
  def root_url
    api_url + "/api/v1/widgets/visible"
  end

  def params
    {
      query: {
        client_id: credentials[:client_id],
        client_secret: credentials[:client_secret]
      },
      headers: {
        "Authorization" => "Bearer #{access_token}"
      }
    }
  end

  def api_request(method, url, params={}, data_object)
    response = HTTParty.send method, url, params
    if response.code == 200
      JSON.parse(response.body)["data"][data_object]
    elsif response.code == 401
      refresh_access_token
      api_request(method, url, params, data_object)
    else
      raise ApiConnectionError, "#{response.code} - #{response.message}"
    end
  end
end
