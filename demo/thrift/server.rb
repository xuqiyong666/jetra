
require "jetra"
require "jetra/adapter/thrift"

class ApiInterface < Jetra::Base

  before do
    puts "#{Time.now} route: #{request.route.inspect} params: #{params.inspect}"
  end

  error do |boom| 

    response.status = 500

    puts ["#{Time.now} #{boom.class} - #{boom.message}:", *boom.backtrace].join("\n\t")

    halt "Internal Server Error"
  end

  route :greeting do
    "hello, world!"
  end

  route :repeat do
    "you said `#{params[:msg] || "nothing"}`"
  end

  route "api2019/create_cat" do

    halt_success(name: "tom", age: 6, color: "black")
  end

end



thriftApp = Jetra::ThriftAdapter.new(ApiInterface)

port = 9090

thirftserver = Jetra::ThriftServer.new(thriftApp, port)

puts "Starting the server..."
thirftserver.serve()

puts "finish.."
