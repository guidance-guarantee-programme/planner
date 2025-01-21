class EditAppointmentForm < SimpleDelegator
  include PostalAddressable

  delegate :realtime?, :primary_slot, :secondary_slot, :tertiary_slot, :agent, :consent, to: :booking_request
  delegate :welsh?, :attended_digital, to: :booking_request

  def update(attributes)
    assign_attributes(attributes)

    return if invalid?

    transaction do
      allocate if allocation_changed?
      super
    end
  end

  def slots
    Schedule
      .current(location_id)
      .without_appointments
      .realtime
  end

  private

  def allocation_changed?
    proceeded_at_changed? || guider_id_changed? || location_id_changed?
  end

  def allocate
    return unless schedule = Schedule.current(location_id)

    slot = schedule.create_realtime_bookable_slot(
      start_at: proceeded_at,
      guider_id: guider_id
    )

    log_errors(slot) if slot.invalid?
  end

  def log_errors(slot)
    logger.warn('Could not allocate missing slot')
    logger.warn("proceeded_at: #{proceeded_at}, guider_id: #{guider_id}, location_id: #{location_id}")
    logger.warn(slot.errors.full_messages.to_sentence)
  end
end
