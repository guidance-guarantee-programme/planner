class Schedule < ActiveRecord::Base
  def self.current(location_id)
    where(location_id: location_id)
      .order(created_at: :desc)
      .first_or_initialize(location_id: location_id)
  end

  def self.slot_attributes
    columns_hash
      .keys
      .select { |k| /_[a|p]m\z/ === k } # rubocop:disable Style/CaseEquality
      .map(&:to_sym)
  end
end
