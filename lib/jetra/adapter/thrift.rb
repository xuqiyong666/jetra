
require 'thrift'

require "jetra/adapter/thrift/jetra_types"
require "jetra/adapter/thrift/jetra_constants"
require "jetra/adapter/thrift/service"

require "set"
require 'json'

module Jetra

  class ThriftAdapter

    def initialize(app, &custom_block)
      @app = app

      @routes = Set.new
      @app.routes.each_key do |route|
        @routes << route
      end

      @custom_block = custom_block

    end

    def call(request)

      if @custom_block
        @custom_block.call(request)
      end

      route = request.route || ""
      
      params = parse_params(request.params)

      sym_route = route.to_sym

      if @routes.include?(sym_route)
        res = @app.call(sym_route, params)
      else
        params[:route] = route
        res = @app.call(:not_found, params)
      end

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

end