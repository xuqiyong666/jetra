
require "jetra"
require "jetra/adapter/thrift"

host = "localhost"
port = 9090

DemoClient = Jetra::ThriftClient.new(host, port)

def call_greeting
  request = Jetra::Thrift::Request.new
  request.route = "greeting"

  DemoClient.call(request)
end


def call_repeat
  request = Jetra::Thrift::Request.new
  request.route = "repeat"
  request.params = {msg: "ok,thrift!"}.to_json

  DemoClient.call(request)
end

def call_api2019
  request = Jetra::Thrift::Request.new
  request.route = "api2019/create_cat"
  request.params = {name: "tom"}.to_json

  DemoClient.call(request)
end

while true

    begin
        puts call_greeting.inspect
        puts call_repeat.inspect
        puts call_api2019.inspect
    rescue => boom
        puts boom.message
    end

    sleep 1
end

puts "finish.."