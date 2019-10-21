
require 'open-uri'
require 'net/http'

params = {msg: "hi,there."}
url = URI.parse('http://localhost:9292/repeat')
response = Net::HTTP.post_form(url, params)

p response.body


