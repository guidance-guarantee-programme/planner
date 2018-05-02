module PusherHelper
  def pusher_setup
    return unless current_user.booking_manager?
    return unless pusher_configured?

    safe_join([pusher_script_tag, pusher_module_tag], "\n")
  end

  def pusher_configured?
    defined?(PusherFake) || ENV['PUSHER_KEY']
  end

  def pusher_module_tag
    config = { event: current_user.booking_location_id }
    content_tag :div, '', data: { module: 'drop-notifications', config: config.to_json }
  end

  def pusher_script_tag
    content_tag(:script, pusher_javascript.html_safe) # rubocop:disable Rails/OutputSafety
  end

  def pusher_javascript
    if defined?(PusherFake)
      %(Pusher.instance = #{PusherFake.javascript})
    else
      %[Pusher.instance = new Pusher("#{ENV['PUSHER_KEY']}", { cluster: "eu", encrypted: true });]
    end
  end
end
