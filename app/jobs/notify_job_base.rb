require 'notifications/client'

class NotifyJobBase < ActiveJob::Base
  queue_as :default

  rescue_from(Notifications::Client::RequestError) do |exception|
    Bugsnag.notify(exception)
  end

  protected

  def client
    @client ||= Notifications::Client.new(api_key)
  end

  def api_key
    ENV['NOTIFY_API_KEY']
  end
end
