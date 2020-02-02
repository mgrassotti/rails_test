class UsersApiClient < ApiClient
  def self.api_url
    "/api/v1/users"
  end

  def self.create(user)
    self.new.create(user)
  end

  def self.reset_password(user)
    self.new.reset_password(user)
  end

  def find(id)
    parse_response(self.class.get("/#{id}", auth_headers))
  end

  def create(user)
    parse_response self.class.post("/",
      body: {
        "client_id": credentials[:client_id],
        "client_secret": credentials[:client_secret],
        "user": user.to_h
      }
    )
  end

  def reset_password(user)
    parse_response self.class.post("/reset_password",
      body: {
        "client_id": credentials[:client_id],
        "client_secret": credentials[:client_secret],
        "user": { email: user.email }
      }
    )
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
        message: response["message"]
      }
    end
  end
end
