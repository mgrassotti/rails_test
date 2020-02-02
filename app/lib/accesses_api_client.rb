class AccessesApiClient < ApiClient
  def self.api_url
    "/oauth"
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

  def new_access_token(username, password)
    parse_response self.class.post("/token",
      body: {
        "grant_type": "password",
        "client_id": credentials[:client_id],
        "client_secret": credentials[:client_secret],
        "username": username,
        "password": password
      }
    )
  end

  def refresh_access_token(refresh_token)
    parse_response self.class.post("/token",
      body: {
        "grant_type": "refresh_token",
        "refresh_token": refresh_token,
        "client_id": credentials[:client_id],
        "client_secret": credentials[:client_secret]
      }
    )
  end

  def revoke_access_token
    self.class.post("/revoke",
      body: {
        "token": access_token
      }.merge(params).merge(auth_headers)
    )
  end

private
  def params
    query
  end

  def query
    {
      query: {
        client_id: credentials[:client_id],
        client_secret: credentials[:client_secret]
      }
    }
  end

  def parse_response(response)
    if response.code == 200
      token_data = response["data"]["token"]
      {
        status: "ok",
        data: {
          access_token: token_data["access_token"],
          refresh_token: token_data["refresh_token"],
          expires_in: token_data["expires_in"],
          expires_at: Time.now + token_data["expires_in"]
        }
      }
    else
      {
        status: "error - #{response.code}",
        message: response["message"]
      }
    end
  end
end
