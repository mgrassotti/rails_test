class ModelFromApi
  def initialize(hash)
    @attributes_hash = hash
    self.class::ATTRIBUTES.each do |attr|
      self.class.define_method(attr) do
        @attributes_hash.with_indifferent_access[attr]
      end
    end
  end

  def self.all(access_token)
    "#{name.to_s.pluralize}ApiClient".constantize.all(access_token).map do |hash|
      self.new(hash)
    end
  end
end

