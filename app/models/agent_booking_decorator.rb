class AgentBookingDecorator < SimpleDelegator
  def first_choice_slot
    if scheduled
      slot_text(super)
    else
      Time.zone.parse(ad_hoc_start_at).to_s(:govuk_date)
    end
  end

  def second_choice_slot
    slot_text(super)
  end

  def third_choice_slot
    slot_text(super)
  end

  def date_of_birth
    super.to_date.to_s(:govuk_date)
  end

  def accessibility_requirements
    super ? 'Yes' : 'No'
  end

  def third_party
    super ? 'Yes' : 'No'
  end

  def pension_provider
    PensionProvider[super]
  end

  alias object __getobj__

  private

  def slot_text(slot)
    return if slot.blank?

    Slot.from(priority: 1, slot: slot).to_s
  end
end
