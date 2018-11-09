class Activity < ActiveRecord::Base
  POLLING_KEY = 'POLL_INTERVAL_MILLISECONDS'.freeze

  belongs_to :booking_request
  belongs_to :user, optional: true

  scope :since, ->(since) { where('created_at > ?', since) }

  def owner_name
    user ? user.name : 'Someone'
  end

  def to_partial_path
    "activities/#{model_name.singular}"
  end
end
