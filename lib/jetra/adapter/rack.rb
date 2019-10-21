
require "set"
require 'json'
require 'rack'

module Jetra

  class RackAdapter

    include Rack::Utils

    def initialize(app, &custom_block)
      @app = app

      @custom_block = custom_block

    end

    def call(env)

      request = Rack::Request.new(env)

      params = indifferent_params(request.params)

      if @custom_block
        @custom_block.call(request, params)
      end

      route = request.path_info
      route.chop! if (char=route[-1]) and char=='/' # ignore last '/' char
      route[0] = '' if route[0]=="/" #remove first '/' char

      sym_route = route.to_sym

      res = @app.call(sym_route, params)

      result = {}
      result[:status] = res.status
      result[:body] = res.body

      ['200', {'Content-Type' => 'application/json;charset=utf-8'}, [result.to_json]]
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