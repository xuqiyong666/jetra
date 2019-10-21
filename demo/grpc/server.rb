
require "jetra"
require "jetra/adapter/grpc"

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

puts "Starting the server..."

bind = '0.0.0.0:50051'

grpcApp = Jetra::GrpcAdapter.new(ApiInterface)

server = Jetra::GrpcServer.new(grpcApp, bind)

server.serve()

puts "finish.."
