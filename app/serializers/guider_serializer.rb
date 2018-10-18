class GuiderSerializer < ActiveModel::Serializer
  attribute :id
  attribute :name, key: :title

  def read_attribute_for_serialization(key)
    object[key.to_s]
  end
end
