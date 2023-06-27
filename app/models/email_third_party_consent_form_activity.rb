class EmailThirdPartyConsentFormActivity < Activity
  def self.from!(booking_request)
    create!(
      booking_request: booking_request,
      message: ''
    )
  end
end
