class Slot < ActiveRecord::Base
  belongs_to :booking_request

  def morning?
    from < '1300'
  end

  def to_s
    "#{date.to_s(:gov_uk)} - #{period}"
  end

  def period
    morning? ? 'morning' : 'afternoon'
  end
end
