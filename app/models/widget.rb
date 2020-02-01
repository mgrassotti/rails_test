class Widget < ModelFromApi
  ATTRIBUTES = %w(id name description kind owner)
  attr_reader :error_message

  def self.find(id)
    self.new({ id: id })
  end

  def user
    User.new @attributes_hash["user"]
  end

  def destroy
    result = WidgetsApiClient.new(access_token).destroy(id)
    if result[:status] == "ok"
      @error_message = nil
      true
    else
      @error_message = result[:message]
      false
    end
  end
end
