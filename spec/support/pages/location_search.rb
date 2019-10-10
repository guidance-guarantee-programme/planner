module Pages
  class LocationSearch < SitePrism::Page
    set_url '/locations'

    element :postcode, '.t-postcode'
    element :submit, '.t-submit'

    sections :locations, '.t-location' do
      element :name, '.t-name'
      element :distance, '.t-distance'
      element :availability, '.t-availability'
      element :book, '.t-book'
    end
  end
end
