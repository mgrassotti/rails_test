class WidgetsApiClient < ApiClient
  def self.api_url
    "/api/v1/widgets"
  end

  def self.search(access=nil, q=nil)
    self.new(access).search(q)
  end

  def self.destroy(id:, access:)
    self.new(access).destroy(id)
  end

  def self.create(access=nil, widget)
    self.new(access).create(widget)
  end

  def search(q=nil)
    search_params = params.dup
    search_params[:query][:term] = q if q.present?
    response = WidgetsApiClient.get '/visible', search_params
    if response.code == 200
      JSON.parse(response.body)["data"]['widgets']
    elsif response.code == 401
      refresh_access_token
      all
    else
      raise ApiConnectionError, "#{response.code} - #{response.message}"
    end
  end

  def create(widget)
    response = WidgetsApiClient.post "/", body: { widget: widget.to_h },
      headers: auth_headers[:headers]
    if response.code == 200
      { status: "ok", data: response["data"] }
    else
      { status: "error - #{response.code}", message: response["message"] }
    end
  end

  def destroy(id)
    response = WidgetsApiClient.delete "/#{id}", auth_headers
    if response.code == 200
      { status: "ok", message: "ok" }
    elsif response.code == 401
      refresh_access_token
      destroy(id)
    else
      { status: "error - #{response.code}", message: response["message"] }
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
