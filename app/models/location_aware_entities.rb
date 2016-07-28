class LocationAwareEntities
  def initialize(entities, booking_location)
    @booking_location = booking_location
    @entities = entities
  end

  def all
    @all ||= entities.map do |entity|
      LocationAwareEntity.new(
        booking_location: booking_location,
        entity: entity
      )
    end
  end

  private

  attr_reader :booking_location, :entities
end
