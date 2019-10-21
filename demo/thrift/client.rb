
require "jetra"
require "jetra/adapter/thrift"

host = "localhost"
port = 9090

DemoClient = Jetra::ThriftClient.new(host, port)

def call_greeting
  request = Jetra::Thrift::Request.new
  request.route = "greeting"
  # request.params = ""

  DemoClient.call(request)
end

puts call_greeting.inspect

puts "finish.."