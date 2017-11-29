
require "jetra"
require "jetra/adapter/thrift"

class ApiInterface < Jetra::Base

  before do
    response.status = 200
  end

  def haltError(boom)
    response.status = 500
    halt "haltError!!!"
  end

  error do |boom| haltError(boom) end

  route :greeting do
    "hello, world!"
  end

  route :repeat do
    "you said `#{params[:msg] || "nothing"}`"
  end

end

thriftApp = Jetra::ThriftAdapter.new(ApiInterface)

# request = Jetra::Thrift::Request.new
# request.route = "greeting"
# request.params = "123"


# request = Jetra::Thrift::Request.new
# request.route = "repeat"
# request.params = {
#   msg: "hear me?"
# }.to_json

# p thriftApp.call(request)

# class ExampleApp

#   def call(request)

#     response = Jetra::Thrift::Reponse.new
#     response.status = 1
#     response.body = {msg: "your request is #{request.inspect}"}.to_s
#     response
#   end

# end

#thriftApp

port = 9090
handler = thriftApp
processor = Jetra::Thrift::Service::Processor.new(handler)
transport = Thrift::ServerSocket.new(port)
transportFactory = Thrift::FramedTransportFactory.new()
server = Thrift::NonblockingServer.new(processor, transport, transportFactory)

puts "Starting the server..."
server.serve()

puts "finish.."
