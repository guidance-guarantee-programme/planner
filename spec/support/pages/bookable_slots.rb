module Pages
  class BookableSlot < SitePrism::Section
    element :appointment_count, '.t-appointment-count'
  end

  class BookableSlots < SitePrism::Page
    set_url '/locations/{location_id}/bookable_slots'

    def slot(bookable_slot)
      BookableSlot.new(self, first(".t-slot-#{bookable_slot.id}"))
    end
  end
end
