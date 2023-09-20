class GuiderSerializer < ActiveModel::Serializer
  attribute :id

  attribute :name, key: :title do
    name = read_attribute_for_serialization(:name)

    first_name, *names = name.split

    "#{first_name.first} #{names.join(' ')}"
  end

  def read_attribute_for_serialization(key)
    object.public_send(key)
  end
end
