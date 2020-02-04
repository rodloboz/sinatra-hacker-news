# TOP STORIES:
# https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty
# INDIVIDUAL STORY:
# https://hacker-news.firebaseio.com/v0/item/8863.json?print=pretty
# UNIX TIME TO DATETIME DateTime.strptime("1175714200", "%s").year

require "date"
require "httparty"

require "byebug"

def fetch_api_response(url)
  response = HTTParty.get(url, format: :plain)
  JSON.parse response, symbolize_names: true
end

def create_post(attrs = {})
  user = User.find_or_create_by(username: attrs[:by]) do |u|
    u.email = "#{attrs[:by]}@lw.com"
  end

  Post.create!(
    name: attrs[:title],
    url: attrs[:url],
    published_at: convert_unix_time_to_datetime(attrs[:time]),
    votes: attrs[:score],
    user: user
  )
end

def convert_unix_time_to_datetime(time)
  DateTime.strptime("#{time}", "%s")
end

BASE_URL = "https://hacker-news.firebaseio.com/v0/"

url = BASE_URL + "topstories.json"
ids = fetch_api_response(url)

ids.take(10).each do |id|
  url =  BASE_URL + "item/#{id}.json"
  attrs = fetch_api_response(url)
  create_post(attrs)
end

puts "Finished seeding!"