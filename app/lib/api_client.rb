class ApiClient
  class ApiConnectionError < StandardError; end
  include HTTParty
  attr_reader :access_token

  def initialize(access=nil)
    @access = access
  end

  def self.root_url
    self.new.root_url
  end

  def self.get(path, params)
    super(root_url + api_url + path, params)
  end

  def self.post(path, params)
    super(root_url + api_url + path, params)
  end

  def self.put(path, params)
    super(root_url + api_url + path, params)
  end

  def self.delete(path, params)
    super(root_url + api_url + path, params)
  end

  def root_url
    Rails.configuration.external_api[:url]
  end

private
  def credentials
    Rails.application.credentials.widget_api
  end

  def credentials_params
    {
      query: {
        "client_id": credentials[:client_id],
        "client_secret": credentials[:client_secret]
      }
    }
  end

  def auth_headers
    {
      headers: {
        "Authorization" => "Bearer #{@access.access_token}"
      }
    }
  end

private
  def parse_response(response)
    if response.code == 200
      {
        status: "ok",
        data: response["data"]
      }
    else
      {
        status: "error - #{response.code}",
        message: response["message"] || "#{response.code} - An error occurred"
      }
    end
  end
end
