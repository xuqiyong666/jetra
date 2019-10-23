
require "jetra/adapter/grpc"

require_relative "demo_pb"

host_and_port = "localhost:50051"

DemoClient = Jetra::Grpc::Client.new(host_and_port)

def send_grpc_request(route, params)

    ptparams = Google::Protobuf::Map.new(:string, :string)

    params.each do |k, v|
        ptparams[k.to_s] = v.to_s
    end

    request = Jetra::Grpc::Request.new
    request.route = route
    request.params = ptparams

    DemoClient.call(request)
end

def call_repeat

    response = send_grpc_request("repeat", { msg: "hi,grpc!" })

    puts "---------------- #{Time.now}------------------"
    puts "status: #{response.status}"
    p response.body.unpack(Google::Protobuf::Value).to_ruby
end

def call_get_product

    response = send_grpc_request("api2019/get_product", { id: "10" })

    puts "---------------- #{Time.now}------------------"
    puts "status: #{response.status}"
    p response.body
    p response.body.unpack(Jetra::GrpcDemo::Product)
    p response.body.type_name

    # p response.body.unpack(response.body.type_name)

end

while true

    begin
        # call_repeat
        call_get_product
    rescue => boom
        raise boom
        puts boom.message
    end

    sleep 1
end

puts "finish.."


