class Widget < ModelFromApi
  ATTRIBUTES = %w(id name description kind owner)

  def user
    User.new @attributes_hash["user"]
  end
end
