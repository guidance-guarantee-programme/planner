module BookingRequestsHelper
  GUIDERS = {
    'Group1' => ['Ben Barnett', 'Ben Lovell', 'Matt Lucht', 'Tim Reichardt'],
    'Group2' => ['Mary Jones', 'David Henry', 'Chris Winfrey', 'Henry Kissinger', 'Harry Doylie'],
    'Group3' => ['Sally Murray', 'Beryl Clerk']
  }

  def guider_by_id(id)
    group = id.sub[0, 5]
    guider = id.sub[5]

    GUIDERS[group][guider]
  end

  def guiders_hash
    GUIDERS.to_json.html_safe
  end

  def guiders
    GUIDERS
  end
end
