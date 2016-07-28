module Pages
  class Appointments < SitePrism::Page
    set_url '/appointments'

    elements :appointments, '.t-appointment'
  end
end
