
require 'thrift'

require "jetra/adapter/thrift/jetra_types"
require "jetra/adapter/thrift/jetra_constants"
require "jetra/adapter/thrift/service"

require 'json'

module Jetra

  class ThriftAdapter

    def initialize(app, &custom_block)
      @app = app

      @custom_block = custom_block
    end

    def call(request)

      route = request.route || ""
      
      params = parse_params(request.params)

      if @custom_block
        @custom_block.call(route, params)
      end

      sym_route = route.to_sym

      res = @app.call(sym_route, params)

      response = Thrift::Response.new
      response.status = res.status
      response.body = res.body.to_json
      response
    end

    def parse_params(params)
      indifferent_params(JSON.load(params).to_h)
    rescue => boom
      {}
    end

    # Enable string or symbol key access to the nested params hash.
    def indifferent_params(object)
      case object
      when Hash
        new_hash = indifferent_hash
        object.each { |key, value| new_hash[key] = indifferent_params(value) }
        new_hash
      when Array
        object.map { |item| indifferent_params(item) }
      else
        object
      end
    end

    # Creates a Hash with indifferent access.
    def indifferent_hash
      Hash.new {|hash,key| hash[key.to_s] if Symbol === key }
    end

  end

  class ThriftServer

    def initialize(handler, port)
      port = port
      processor = Thrift::Service::Processor.new(handler)
      transport = ::Thrift::ServerSocket.new(port)
      transportFactory = ::Thrift::FramedTransportFactory.new()
      @server = ::Thrift::NonblockingServer.new(processor, transport, transportFactory)
    end

    def serve
      @server.serve()
    end

  end

  class ThriftClient

    def initialize(host, port)

      transport = ::Thrift::FramedTransport.new(::Thrift::Socket.new(host, port))
      protocol = ::Thrift::BinaryProtocol.new(transport)

      @transport = transport

      @client = Thrift::Service::Client.new(protocol)
    end

    def call(request)

      @client.call(request)

    rescue ::Thrift::TransportException, IOError => boom

      establish_connection

      @client.call(request)

    end

    def establish_connection
      @transport.open
    end

  end

end