class Geocoder
  FailedLookup  = Class.new(StandardError)
  InvalidLookup = Class.new(StandardError)

  def self.lookup(postcode)
    raise InvalidLookup unless lookup = perform_lookup(postcode)

    [lookup.latitude, lookup.longitude]
  end

  def self.perform_lookup(postcode)
    Postcodes::IO.new.lookup(postcode)
  rescue
    raise FailedLookup
  end
end
