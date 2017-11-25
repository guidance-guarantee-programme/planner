module Pages
  class AgentBooking < SitePrism::Page
    set_url '/locations/{location_id}/booking_requests/new'

    element :errors, '.t-errors'

    element :first_choice_slot, '.t-first-choice-slot'
    element :second_choice_slot, '.t-second-choice-slot'
    element :third_choice_slot, '.t-third-choice-slot'

    element :name, '.t-name'
    element :phone, '.t-phone'
    element :memorable_word, '.t-memorable-word'
    element :date_of_birth, '.t-date-of-birth'
    element :accessibility_requirements, '.t-accessibility-requirements'
    element :terms_and_conditions, '.t-terms-and-conditions'
    element :defined_contribution_pot_confirmed_yes, '.t-defined-contribution-pot-confirmed-yes'
    element :defined_contribution_pot_confirmed_dont_know, '.t-defined-contribution-pot-confirmed-dont-know'
    element :where_you_heard, '.t-where-you-heard'

    element :email, '.t-email'
    element :address_line_one, '.t-address-line-one'
    element :address_line_two, '.t-address-line-two'
    element :address_line_three, '.t-address-line-three'
    element :town, '.t-town'
    element :county, '.t-county'
    element :postcode, '.t-postcode'
    element :country, '.t-country'
    element :additional_info, '.t-additional-info'

    element :preview, '.t-preview'
  end
end
