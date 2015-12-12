require 'pusher'

Pusher.url    = ENV['pusher_URL']
Pusher.app_id = ENV['pusher_app_id']
Pusher.key    = ENV['pusher_key']
Pusher.secret = ENV['pusher_secret']
