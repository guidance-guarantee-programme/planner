module ActivityHelper
  def timestamp(created_at)
    zoned = created_at.in_time_zone('London')

    "#{zoned.to_s(:govuk_date)} (#{time_ago_in_words(zoned)} ago)"
  end
end
