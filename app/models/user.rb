class User < ModelFromApi
  ATTRIBUTES = %w(id name images image_url first_name last_name email)
  attr_reader :error_message

  def self.find(access=nil, id)
    response = UsersApiClient.new(access).find(id)
    if response[:status] == "ok"
      { status: "ok", data: self.new(response[:data]["user"])}
    else
      { status: response[:status], error_message: response[:message] }
    end
  end

  def self.me(access=nil)
    return nil unless access && access.logged_in?
    new UsersApiClient.me(access)[:data]["user"]
  end

  def save
    response = UsersApiClient.create(self)
    if response[:status] == "ok"
      Access.new.token_data = response[:data]["token"]
      true
    else
      @error_message = response[:message]
      false
    end
  end

  def reset_password
    response = UsersApiClient.reset_password(self)
    if response[:status] == "ok"
      response[:data]
    else
      @error_message = response[:message]
      false
    end
  end

  def widgets(access=nil, q=nil)
    response = UsersApiClient.new(access).widgets(id, q)
    if response[:status] == "ok"
      response[:data]["widgets"].map { |w| Widget.new(w) }
    else
      @error_message = response[:message]
      []
    end
  end
end
