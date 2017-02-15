class MordenClosure < ActiveRecord::Migration[5.0]
  def up
    BookingRequest
      .where(booking_location_id: '253a5060-9fc7-4936-8ab2-805b8ac0e781')
      .update_all(booking_location_id: '848a0ab6-d59f-4f4c-93fb-acc0360af89d')
  end

  def down
    # noop
  end
end
