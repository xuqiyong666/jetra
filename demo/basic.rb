
#首先写一个基本的接口类

require "jetra"

class ApiInterface < Jetra::Base

  route "greeting" do
    "hello, world!"
  end

  route "repeat" do
    "you said `#{params["msg"] || "nothing"}`"
  end

end


p ApiInterface.call("greeting")

p ApiInterface.call("repeat", "msg" => "I am fine") 

bind = '0.0.0.0:50051'

grpcApp = Jetra::Grpc::Adapter.new(ApiInterface)

server = Jetra::Grpc::Server.new(grpcApp, bind)

puts "Starting the server..."
server.serve()

puts "finish"




