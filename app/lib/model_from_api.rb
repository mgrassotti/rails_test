class ModelFromApi
  def initialize(hash)
    @attributes_hash = hash
    self.class::ATTRIBUTES.each do |attr|
      self.class.define_method(attr) do
        @attributes_hash[attr]
      end
    end
  end

  def self.all
    "#{name.to_s.pluralize}ApiClient".constantize.all.map do |hash|
      self.new(hash)
    end
  end
end

