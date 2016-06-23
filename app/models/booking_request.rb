class BookingRequest < ActiveRecord::Base
  has_many :slots

  accepts_nested_attributes_for :slots, limit: 3, allow_destroy: false
end
