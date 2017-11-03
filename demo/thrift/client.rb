
require "jetra"
require "jetra/adapter/thrift"

port = 9090

transport = Thrift::BufferedTransport.new(Thrift::Socket.new('127.0.0.1', port))
protocol = Thrift::BinaryProtocol.new(transport)
DemoClient = Jetra::Thrift::Service::Client.new(protocol)

transport.open

request = Jetra::Thrift::Request.new
request.route = "greeting"
request.params = ""

p DemoClient.call(request)

request = Jetra::Thrift::Request.new
request.route = "repeat"
request.params = {
  msg: "hear me?"
}.to_json

p DemoClient.call(request)



puts "finish.."