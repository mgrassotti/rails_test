class ModelFromApi
  def initialize(hash={})
    @attributes_hash = hash.to_h
    self.class::ATTRIBUTES.each do |attr|
      self.class.define_method(attr) do
        @attributes_hash.with_indifferent_access[attr]
      end
    end
  end

  def to_h
    @attributes_hash
  end
end

