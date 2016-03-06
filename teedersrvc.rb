require 'rubygems'
require 'bundler/setup'
Bundler.require :default
require 'json'

REDIS_KEY = 'teeder_status'
REDIS = Redis.new

def from_redis(number_of_updates)
  data = JSON.parse REDIS.get('hubot:storage')
  updates = data["_private"]["teeder_status"]
  updates.take(number_of_updates+1)
end

def updates(number_of_updates=5)
  JSON.generate from_redis(number_of_updates)
end

get '/' do
  updates
end

get '/:number_of_updates' do |number_of_updates|
  updates number_of_updates.to_i - 1
end
