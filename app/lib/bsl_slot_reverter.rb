class BslSlotReverter
  def call
    BookableSlot.bsl_slots_to_revert.update_all(bsl: false) # rubocop:disable Rails/SkipsModelValidations
  end
end
