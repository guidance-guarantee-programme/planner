Pusher.app_id = ENV.fetch('PUSHER_APP_ID') { 'pension_wise_planner' }
Pusher.key    = ENV.fetch('PUSHER_KEY')    { 'pusher_key' }
Pusher.secret = ENV.fetch('PUSHER_SECRET') { 'pusher_secret' }

require 'pusher-fake/support/base' if Rails.env.development?
