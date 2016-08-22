class Activity < ActiveRecord::Base
  belongs_to :booking_request
  belongs_to :user

  def owner_name
    user ? user.name : 'Someone'
  end

  def to_partial_path
    "activities/#{model_name.singular}"
  end
end
