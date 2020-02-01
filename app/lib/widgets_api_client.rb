class WidgetsApiClient < ApiClient
  def self.api_url
    "/api/v1/widgets"
  end

  def all
    response = WidgetsApiClient.get '/visible', params
    if response.code == 200
      JSON.parse(response.body)["data"]['widgets']
    elsif response.code == 401
      refresh_access_token
      all
    else
      raise ApiConnectionError, "#{response.code} - #{response.message}"
    end
  end

  def destroy(id)
    response = WidgetsApiClient.delete "/#{id}", headers
    if response.code == 200
      { status: "ok", message: "ok" }
    elsif response.code == 401
      refresh_access_token
      destroy(id)
    else
      { status: "error" , message: "#{response.code} - #{response.message}" }
    end
  end

private
  def params
    access_token ? query.merge(auth_headers) : query
  end

  def query
    {
      query: {
        client_id: credentials[:client_id],
        client_secret: credentials[:client_secret]
      }
    }
  end
end
