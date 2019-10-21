
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

port = 9090

thirftserver = Jetra::ThriftServer.new(thriftApp, port)

puts "Starting the server..."
thirftserver.serve()

puts "finish.."
