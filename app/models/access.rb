class Access < ModelFromApi
  ATTRIBUTES = %w(email password)
  attr_reader :error_message

  def token_data
    Rails.cache.read(email).try(:with_indifferent_access)
  end

  def token_data=(hash)
    Rails.cache.write(email, hash, expires_in: hash[:expires_in])
  end

  def access_token
    token_data && token_data[:access_token]
  end

  def refresh_token
    token_data && token_data[:refresh_token]
  end

  def save
    if token_data
      expired? ? refresh_token && refresh_access_token : true
    else
      email.present? && password.present? && get_new_access_token
    end
  end
  alias_method :login, :save

  def save!
    save || raise(@error_message)
  end
  alias_method :login!, :save!

  def destroy
    AccessesApiClient.revoke_access_token(self)
  end

  def logged_in?
    !!access_token
  end

private
  def expired?
    Time.now > token_data[:expires_at]
  end

  def get_new_access_token
    save_response AccessesApiClient.new_access_token(email, password)
  end

  def refresh_access_token
    save_response AccessesApiClient.refresh_access_token(refresh_token)
  end

  def save_response(response)
    if response[:status] == "ok"
      self.token_data = response[:data]
      true
    else
      @error_message = response[:message]
      false
    end
  end
end
