class OrganisationLookup < ActiveRecord::Base
  def self.populate
    Appointment.distinct.pluck(:location_id).each do |location_id|
      if location = BookingLocations.find(location_id)
        find_or_create_by(location_id: location_id, organisation: location.organisation)
      else
        logger.warn("Location could not be found for: #{location_id}")
      end
    end
  end

  def self.cas_location_ids
    for_organisation('cas')
  end

  def self.pwni_location_ids
    for_organisation('nicab')
  end

  def self.for_organisation(*organisations)
    where(organisation: organisations).pluck(:location_id)
  end
end
