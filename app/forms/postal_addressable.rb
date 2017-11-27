module PostalAddressable
  def postal_confirmation?
    booking_request.address_line_one? && email_withheld?
  end

  def email_withheld?
    email.blank? || email == 'tpbookings@pensionwise.gov.uk'
  end

  def postal_address_lines
    [
      booking_request.address_line_one,
      booking_request.address_line_two,
      booking_request.address_line_three,
      booking_request.town,
      booking_request.county,
      booking_request.postcode
    ].reject(&:blank?).join("\n")
  end
end
