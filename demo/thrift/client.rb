
require "jetra"
require "jetra/adapter/thrift"

class JetraClient

  def initialize(host, port)

    transport = Thrift::FramedTransport.new(Thrift::Socket.new(host, port))
    protocol = Thrift::BinaryProtocol.new(transport)

    @transport = transport

    @client = Jetra::Thrift::Service::Client.new(protocol)

    establish_connection
  end

  def call(request)

    @client.call(request)

  rescue Thrift::TransportException, IOError => boom

    establish_connection

    @client.call(request)

  end

  def establish_connection
    @transport.open
  end

end


host = "127.0.0.1"
port = 9090

DemoClient = JetraClient.new(host, port)

#p transport.methods

# transport.open

def call_greeting
  request = Jetra::Thrift::Request.new
  request.route = "greeting"
  request.params = ""

  DemoClient.call(request)
end

while true
  p call_greeting
  puts ""
  sleep 1
end


# request = Jetra::Thrift::Request.new
# request.route = "repeat"
# request.params = {
#   msg: "hear me?"
# }.to_json

# p DemoClient.call(request)



puts "finish.."