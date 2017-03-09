class BookingLocationDecorator < SimpleDelegator
  def name
    if hidden?
      "[HIDDEN] #{super}"
    else
      super
    end
  end

  def locations
    super.map { |l| BookingLocationDecorator.new(l) }
  end

  alias object __getobj__
end
