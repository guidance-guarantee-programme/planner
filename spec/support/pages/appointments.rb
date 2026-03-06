module Pages
  class Appointments < SitePrism::Page
    set_url '/appointments'

    sections :appointments, '.t-appointment' do
      element :edit, '.t-edit'
      element :video_link, '.t-video-link'
    end

    section :search, '.t-search' do
      element :search_term, '.t-search-term'
      element :status, '.t-status'
      element :location, '.t-location'
      element :guider, '.t-guider'
      element :video_link, '.t-video-link'

      element :submit, '.t-submit'
    end
  end
end
