class PostalAddressForm < SimpleDelegator
  include ActiveModel::Validations

  validates :address_line_one, presence: true
  validates :town, presence: true
  validates :postcode, presence: true

  def update(attrs)
    assign_attributes(attrs)
    save if valid?
  end
end
