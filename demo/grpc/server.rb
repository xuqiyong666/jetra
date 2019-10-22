
require "jetra"
require "jetra/adapter/grpc"

class ApiInterface < Jetra::Base

    before do
        response.status = 200
    end

    def haltError(boom)
        response.status = 500

        halt "Internal Server Error" if Settings[:env] == "production"
    end

    error do |boom| haltError(boom) end

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

puts "Starting the server..."

bind = '0.0.0.0:50051'

grpcApp = Jetra::GrpcAdapter.new(ApiInterface) do |route, params|
    puts "#{Time.now} route: #{route.inspect} params: #{params.inspect}"
end

server = Jetra::GrpcServer.new(grpcApp, bind)

server.serve()

puts "finish.."
