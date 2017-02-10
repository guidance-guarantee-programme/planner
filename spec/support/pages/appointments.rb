module Pages
  class Appointments < SitePrism::Page
    set_url '/appointments'

    sections :appointments, '.t-appointment' do
      element :edit, '.t-edit'
    end

    section :search, '.t-search' do
      element :search_term, '.t-search-term'
      element :status, '.t-status'
      element :location, '.t-location'
      element :guider, '.t-guider'

      element :submit, '.t-submit'
    end
  end
end
