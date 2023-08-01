module RequiredHelper
  def required_label(field = nil)
    content_tag(:strong, field.to_s.humanize)
  end
end
