module Pages
  class Appointments < SitePrism::Page
    set_url '/appointments'

    sections :appointments, '.t-appointment' do
      element :edit, '.t-edit'
    end
  end
end
