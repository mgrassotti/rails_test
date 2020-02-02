class Widget < ModelFromApi
  ATTRIBUTES = %w(id name description kind owner)
  attr_reader :error_message

  def self.all(access_token)
    search(access_token, nil)
  end

  def self.find(current_user, access, id)
    current_user.widgets(access).select{|w| w.id == id.to_i}.first ||
      raise("Could not find a widget with id #{id}")
  end

  def self.search(access_token, q)
    WidgetsApiClient.search(access_token, q).map do |hash|
      self.new(hash)
    end
  end

  def save(access)
    parse_response WidgetsApiClient.create(access, self)
  end

  def update(access, params)
    parse_response WidgetsApiClient.update(access, self.id, params.to_h)
  end

  def user
    User.new @attributes_hash["user"]
  end

  def destroy(access)
    parse_response WidgetsApiClient.new(access).destroy(id)
  end

private
  def parse_response(response)
    if response[:status] == "ok"
      @error_message = nil
      true
    else
      @error_message = response[:message]
      false
    end
  end
end
