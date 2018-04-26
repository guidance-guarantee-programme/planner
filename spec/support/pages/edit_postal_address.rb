module Pages
  class EditPostalAddress < SitePrism::Page
    set_url '/booking_requests/{id}/postal_address/edit'

    element :errors, '.t-errors'

    element :address_line_one, '.t-address-line-one'
    element :address_line_two, '.t-address-line-two'
    element :address_line_three, '.t-address-line-three'
    element :town, '.t-town'
    element :county, '.t-county'
    element :postcode, '.t-postcode'

    element :submit, '.t-submit'
    element :cancel, '.t-cancel'
  end
end
