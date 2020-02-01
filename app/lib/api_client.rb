class ApiClient
  class ApiConnectionError < StandardError; end
  include HTTParty
  attr_reader :access_token

  def initialize(access_token=nil)
    @access_token = access_token
  end

  def self.search(access_token=nil, q=nil)
    self.new(access_token).search(q)
  end

  def self.destroy(id:, access_token:)
    self.new(access_token).destroy(id)
  end

  def self.root_url
    self.new.root_url
  end

  def self.new_access_token(username, password)
    self.new.new_access_token(username, password)
  end

  def self.refresh_access_token(refresh_token)
    self.new.refresh_access_token(refresh_token)
  end

  def self.revoke_access_token
    self.new.revoke_access_token
  end

  def self.get(path, params)
    super(root_url + api_url + path, params)
  end

  def self.post(path, params)
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

  def auth_headers
    {
      headers: {
        "Authorization" => "Bearer #{access_token}"
      }
    }
  end
end
