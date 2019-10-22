
require 'grpc'
require "jetra/adapter/grpc"

host_and_port = "localhost:50051"

DemoClient = Jetra::GrpcClient.new(host_and_port)

def call_greeting

    request = Jetra::Grpc::JetraRequest.new
    request.route = "greeting"

    DemoClient.call(request)
end

def call_repeat

    request = Jetra::Grpc::JetraRequest.new
    request.route = "repeat"
    request.params = {msg: "ok,grpc!"}.to_json

    DemoClient.call(request)
end

def call_api2019

    request = Jetra::Grpc::JetraRequest.new
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


