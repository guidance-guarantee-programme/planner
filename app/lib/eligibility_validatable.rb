module EligibilityValidatable
  def self.included(base)
    base.validate :validate_eligibility
  end

  private

  def parsed_date_of_birth
    date_of_birth.to_date
  rescue ArgumentError
    nil
  end

  def validate_eligibility
    unless %r{\d{1,2}/\d{1,2}/\d{4}}.match?(date_of_birth) && parsed_date_of_birth
      errors.add(:date_of_birth, 'must be formatted eg 01/01/1950')
      return
    end

    errors.add(:base, 'Must be aged 50 or over to be eligible') if age.positive? && age < 50
  end

  def age
    return 0 unless at = earliest_slot_time
    return 0 unless date_of_birth = parsed_date_of_birth

    age = at.year - date_of_birth.year
    age -= 1 if at.to_date < date_of_birth + age.years
    age
  end
end
