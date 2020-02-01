class WidgetsApiClient < ApiClient
  def self.all
    self.new.all
  end

  def self.destroy(id)
    self.new.destroy(id)
  end

  def self.root_url
    self.new.root_url
  end

  def self.get(path, params)
    super(root_url + path, params)
  end
  def self.delete(path, params)
    super(root_url + path, params)
  end

  def root_url
    api_url + "/api/v1/widgets"
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
    query.merge(headers)
  end

  def query
    {
      query: {
        client_id: credentials[:client_id],
        client_secret: credentials[:client_secret]
      }
    }
  end

  def headers
    {
      headers: {
        "Authorization" => "Bearer #{access_token}"
      }
    }
  end

  def api_request(method, path, params={}, data_object)
    response = HTTParty.send method, root_url + path, params
    if response.code == 200
      JSON.parse(response.body)["data"][data_object]
    elsif response.code == 401
      refresh_access_token
      api_request(method, path, params, data_object)
    else
      raise ApiConnectionError, "#{response.code} - #{response.message}"
    end
  end
end
