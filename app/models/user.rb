class User
  def has_permission?(*) # rubocop:disable Style/PredicateName
    false
  end

  def permissions
    []
  end

  def update_attribute(*)
  end

  def clear_remotely_signed_out!
  end

  def remotely_signed_out?
  end
end
