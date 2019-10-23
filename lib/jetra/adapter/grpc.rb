
require 'grpc'

require "jetra/adapter/grpc/jetra_pb"
require "jetra/adapter/grpc/jetra_services_pb"

require "google/protobuf/well_known_types"

require 'json'

module Jetra

    module Grpc

        class Adapter < Interface::Service

            def initialize(app, &custom_block)
                
                @app = app
    
                @custom_block = custom_block
            end
    
            def call(request, _unused_call)
    
                if @custom_block
                    @custom_block.call(request)
                end
    
                res = @app.call(request.route, request.params, request.headers, request.body)
    
                anyBody = Google::Protobuf::Any.new
                anyBody.pack(res.body)
    
                response = Response.new
                response.status = res.status
                response.body = anyBody
                response
            end
            
        end
    
        class Server
    
            def initialize(handler, bind)
    
                server = ::GRPC::RpcServer.new
                server.add_http2_port(bind, :this_port_is_insecure)
                server.handle(handler)
    
                @server = server
            end
    
            def serve
                @server.run_till_terminated_or_interrupted([1, 'int', 'SIGQUIT'])
            end
        end
    
        class Client
    
            def initialize(host_and_port)
                @client = Interface::Stub.new(host_and_port, :this_channel_is_insecure)
            end
    
            def call(request)
                @client.call(request)
            end
    
        end
    end
end
