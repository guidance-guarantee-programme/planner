module BslSlottable
  def self.included(base)
    base.validate :validate_bsl_slot_allocation
    base.validate :validate_bsl_option
  end

  private

  def bsl_slot?
    first_choice_slot.starts_with?(BookableSlot::BSL_SLOT_DESIGNATOR)
  end

  def validate_bsl_option
    return unless bsl? && !bsl_slot?

    errors.add(:base, 'BSL/double slot must be selected when the BSL option is checked')
  end

  def validate_bsl_slot_allocation
    return unless bsl_slot?
    return if bsl? || accessibility_requirements?

    errors.add(:base, 'BSL or adjustments must be specified when choosing a BSL/double slot')
  end
end
