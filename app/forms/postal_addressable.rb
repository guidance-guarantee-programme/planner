module PostalAddressable
  def postal_confirmation?
    __booking_request__.address_line_one? && email_withheld?
  end

  def email_withheld?
    email.blank? || email == 'tpbookings@pensionwise.gov.uk'
  end

  def postal_address_lines
    [
      __booking_request__.address_line_one,
      __booking_request__.address_line_two,
      __booking_request__.address_line_three,
      __booking_request__.town,
      __booking_request__.county,
      __booking_request__.postcode
    ].reject(&:blank?).join("\n")
  end

  def __booking_request__
    respond_to?(:booking_request) ? booking_request : self
  end
end
