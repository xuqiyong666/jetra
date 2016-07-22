require "jetra/interface"

module Jetra

  class NotFoundException < Exception ; end

  class Halt ; end

  class Request

    attr_accessor :route, :params

    def initialize(route, params)
      @route = route || ""
      @params = params || {}
    end
  end

  class Response
    
    attr_reader :status, :body

    def initialize(status=0, body=nil)
      @status = status.to_i
      @body = body
    end

    def status=(value)
      @status = value
    end

    def body=(value)
      @body = value
    end

    def finish
      self.freeze
    end
  end

  class Base

    attr_accessor :request, :response, :params

    def call(route, params)
      dup.call!(route, params)
    end

    def call!(route, params)

      @request  = Request.new(route, params)
      @response = Response.new

      @params   = indifferent_params(@request.params)

      invoke { dispatch! }

      @response.finish
    end

    def current_class
      self.class
    end

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

    def indifferent_hash
      Hash.new {|hash,key| hash[key.to_s] if Symbol === key }
    end

    def invoke
      res = catch(Halt) { yield }

      if Array === res
        res = res.dup
        
        if status = res.shift
          response.status = status
        end

        if body = res.shift
          response.body = body
        end
      else
        if res
          response.body = res
        end
      end
      nil
    end

    def dispatch!
      filter! :before
      route!
    rescue ::Exception => boom
      gotError = true
      handle_exception!(boom)
    ensure
      begin
        filter! :after
      rescue ::Exception => boom
        handle_exception!(boom) unless gotError
      end
    end

    def handle_exception!(boom)

      response.status = 0

      error_block!(boom.class, boom)

      raise boom
    end

    def halt(*response)
      response = response.first if response.length == 1
      throw Halt, response
    end

    def filter!(type)
      current_class.filters[type].each do |args|
        process_route(*args)
      end
    end

    def route!

      if block = current_class.routes[@request.route.to_sym]
        process_route do |*args|
          route_eval { block[*args] }
        end
      end

      route_missing
    end

    def error_block!(error_class, *block_params)

      if error_blocks = current_class.errors[error_class]
        error_blocks.reverse_each do |error_block|
          args = [error_block]
          args += [block_params]
          resp = process_route(*args)
        end
      end

      if error_class.respond_to? :superclass and error_class.superclass <= Exception
        error_block!(error_class.superclass, *block_params)
      end
    end

    def route_eval
      throw Halt, yield
    end

    def process_route(block=nil,values=[])
      block ? block[self,values] : yield(self,values)
    end

    def route_missing
      raise NotFoundException.new("`#{request.route}` Method not found")
    end

    class << self

      attr_accessor :routes, :filters, :errors

      def prototype
        @prototype ||= new
      end

      def call(route, params={})
        prototype.call(route, params)
      end

      def before(&block)
        add_filter(:before, &block)
      end

      def after(&block)
        add_filter(:after, &block)
      end

      def add_filter(type, &block)
        @filters[type] << compile!(&block)
      end

      def route(symbol, &block)
        block ||= Proc.new { method(symbol).call }
        @routes[symbol] = compile!(&block)
      end

      def error(*codes, &block)
        codes = codes.map { |c| Array(c) }.flatten
        codes << Exception if codes.empty?
        codes.each { |c| (@errors[c] ||= []) << compile!(&block) }
      end

      def generate_unbound_method(&block)
        method_name = :id  #any symbol is ok.
        define_method(method_name, &block)
        method = instance_method method_name
        remove_method method_name
        method
      end

      def compile!(&block)

        unbound_method = generate_unbound_method(&block)

        block.arity != 0 ?
          proc { |a,p| unbound_method.bind(a).call(*p) } :
          proc { |a,p| unbound_method.bind(a).call }
      end

      def inherited(subclass)

        subclass.routes = @routes
        subclass.filters = @filters
        subclass.errors = @errors

        Jetra::Base.reset!

        super
      end

      def to_interface

        interface = Jetra::Interface.new
        @routes.each_key do |route|
          eval("interface.define_singleton_method(route) do |params={}| ; #{self.name}.call(route, params) ; end ")
        end

        eval("interface.define_singleton_method(:method_missing) do |method_name, params={}| ; #{self.name}.call(method_name, params) ; end ")

        interface
      end

      def reset!
        @routes         = {}
        @filters        = {:before => [], :after => []}
        @errors         = {}
      end

    end

    reset!

  end
end