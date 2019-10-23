
require "jetra"
require "jetra/adapter/grpc"

require_relative "demo_pb"

class ApiInterface < Jetra::Base

    def halt_text(text)

        proto_val = Google::Protobuf::Value.new
        proto_val.from_ruby(text)

        response.body = proto_val

        halt
    end

    before do
        puts "#{Time.now} request route #{request.route.inspect} params: #{request.params.inspect}"
    end

    after do
        puts "#{Time.now} #{response.status} #{request.route.inspect} #{request.params.inspect}"
    end


    error do |boom|
        response.status = 500
        raise boom
        
    end

    route :repeat do

        halt_text "you said `#{params["msg"] || "nothing"}`"
    end

    route "api2019/get_product" do

        product = Jetra::GrpcDemo::Product.new
        product.id = params["id"].to_i
        product.name = "Egg"
        product.price = 1.5

        product
    end

end

puts "Starting the server..."

bind = '0.0.0.0:50051'

grpcApp = Jetra::Grpc::Adapter.new(ApiInterface)

server = Jetra::Grpc::Server.new(grpcApp, bind)

server.serve()

puts "finish.."
