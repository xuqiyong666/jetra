require "jetra/application"

module Jetra

  class NotFoundException < Exception ; end

  class Halt < Exception ; end

  class Request

    attr_accessor :route, :params

    def initialize(route, params)
      @route = route || ""
      @params = params || {}
    end
  end

  class Response
    
    attr_accessor :status, :body

    def initialize(status=-1, body="")
      @status = status.to_i
      @body = body
    end

    def finish
      self.freeze
    end
  end

  class Base

    Settings = {}
    Settings[:env] = "development"

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
        newHash = indifferent_hash
        object.each { |key, value| newHash[key] = indifferent_params(value) }
        newHash
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

      response.status = -1

      error_block!(boom.class, boom)

      raise boom
    end

    def halt(*response)
      response = response.first if response.length == 1
      throw Halt, response
    end

    def filter!(type)
      current_class.filters[type].each do |args|
        processRoute(*args)
      end
    end

    def route!

      if block = current_class.routes[@request.route.to_sym]
        processRoute do |*args|
          routeEval { block[*args] }
        end
      end

      route_missing
    end

    def error_block!(errorClass, *blockParams)

      if errorBlocks = current_class.errors[errorClass]
        errorBlocks.reverse_each do |errorBlock|
          args = [errorBlock]
          args += [blockParams]
          resp = processRoute(*args)
        end
      end

      if errorClass.respond_to? :superclass and errorClass.superclass <= Exception
        error_block!(errorClass.superclass, *blockParams)
      end
    end

    def routeEval
      throw Halt, yield
    end

    def processRoute(block=nil,values=[])
      block ? block[self,values] : yield(self,values)
    end

    def route_missing
      raise NotFoundException.new("route not found")
    end

    def success_response(body, status=0)

      raise "status code must >= 0 when success" if status < 0

      response.body = body
      response.status = status
    end

    def failure_response(body, status=-1)

      raise "status code must <= -1 when failure" if status > -1

      response.body = body
      response.status = status
    end

    def halt_success(body, status=0)
      success_response(body, status)
      halt
    end

    def halt_failure(body, status=-1)
      failure_response(body, status)
      halt
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

      def route(string, &block)
        symbol = string.to_sym
        block ||= Proc.new { method(symbol).call }
        @routes[symbol] = compile!(&block)
      end

      def error(*codes, &block)
        codes = codes.map { |c| Array(c) }.flatten
        codes << Exception if codes.empty?
        codes.each { |c| (@errors[c] ||= []) << compile!(&block) }
      end

      def generateUnboundMethod(&block)
        methodName = :id  #any symbol is ok.
        define_method(methodName, &block)
        method = instance_method methodName
        remove_method methodName
        method
      end

      def compile!(&block)

        unboundMethod = generateUnboundMethod(&block)

        block.arity != 0 ?
          proc { |a,p| unboundMethod.bind(a).call(*p) } :
          proc { |a,p| unboundMethod.bind(a).call }
      end

      def inherited(subclass)

        subclass.routes = copy_routes
        subclass.filters = copy_filters
        subclass.errors = copy_errors

        super
      end

      def copy_routes
        newRoutes = {}
        @routes.each do |key, value|
          newRoutes[key] = value
        end
        newRoutes
      end

      def copy_filters
        newFilters = {}
        @filters.each do |key, values|
          newValues = []
          values.each do |value|
            newValues << value
          end
          newFilters[key] = newValues
        end
        newFilters
      end

      def copy_errors
        newErrors = {}
        @errors.each do |key, values|
          newValues = []
          values.each do |value|
            newValues << value
          end
          newErrors[key] = newValues
        end
        newErrors
      end

      def to_app

        newApp = Jetra::Application.new(self)
        @routes.each_key do |route|
          eval("newApp.define_singleton_method(route) do |params={}| ; @app.call(route, params) ; end ")
        end

        eval("newApp.define_singleton_method(:method_missing) do |methodName, params={}| ; @app.call(methodName, params) ; end ")

        newApp
      end
      
    end

    @routes         = {}
    @filters        = {:before => [], :after => []}
    @errors         = {}

    error do |boom|

      boommsg = "#{boom.class} - #{boom.message}"

      if boom.class == Jetra::NotFoundException
        trace = []
      else
        trace = boom.backtrace
        trace.unshift boommsg
      end
      response.body = {msg: boommsg, class: boom.class.to_s, route: request.route, params: params, trace: trace}
      halt
    end

  end
end