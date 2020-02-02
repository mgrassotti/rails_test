class User < ModelFromApi
  ATTRIBUTES = %w(id name images first_name last_name email)
  attr_reader :error_message

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
end
