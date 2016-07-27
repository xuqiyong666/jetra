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
    
    attr_accessor :status, :body

    def initialize(status=0, body=nil)
      @status = status.to_i
      @body = body
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

      @params   = indifferentParams(@request.params)

      invoke { dispatch! }

      @response.finish
    end

    def currentClass
      self.class
    end

    def indifferentParams(object)
      case object
      when Hash
        newHash = indifferentHash
        object.each { |key, value| newHash[key] = indifferentParams(value) }
        newHash
      when Array
        object.map { |item| indifferentParams(item) }
      else
        object
      end
    end

    def indifferentHash
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
      handleException!(boom)
    ensure
      begin
        filter! :after
      rescue ::Exception => boom
        handleException!(boom) unless gotError
      end
    end

    def handleException!(boom)

      response.status = 0

      errorBlock!(boom.class, boom)

      raise boom
    end

    def halt(*response)
      response = response.first if response.length == 1
      throw Halt, response
    end

    def filter!(type)
      currentClass.filters[type].each do |args|
        processRoute(*args)
      end
    end

    def route!

      if block = currentClass.routes[@request.route.to_sym]
        processRoute do |*args|
          routeEval { block[*args] }
        end
      end

      routeMissing
    end

    def errorBlock!(errorClass, *blockParams)

      if errorBlocks = currentClass.errors[errorClass]
        errorBlocks.reverse_each do |errorBlock|
          args = [errorBlock]
          args += [blockParams]
          resp = processRoute(*args)
        end
      end

      if errorClass.respond_to? :superclass and errorClass.superclass <= Exception
        errorBlock!(errorClass.superclass, *blockParams)
      end
    end

    def routeEval
      throw Halt, yield
    end

    def processRoute(block=nil,values=[])
      block ? block[self,values] : yield(self,values)
    end

    def routeMissing
      raise NotFoundException.new("route not found")
    end

    def successResponse(body, args = {status: 1})
      status = args[:status]
      raise "status code must >= 1 when using success" if status < 1

      if body.class == String
        body = {msg: body}
      end

      response.body = body
      response.status = status
      nil
    end

    def failureResponse(body, args = {status: -1})
      status = args[:status]
      raise "status code must <= -1 when using failure" if status > -1

      if body.class == String
        body = {msg: body}
      end

      response.body = body
      response.status = status
      nil
    end

    def haltSuccess(body, args = {status: 1})
      halt successResponse(body, args)
    end

    def haltFailure(body, args ={status: -1})
      halt failureResponse(body, args)
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
        addFilter(:before, &block)
      end

      def after(&block)
        addFilter(:after, &block)
      end

      def addFilter(type, &block)
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

        subclass.routes = copyRoutes
        subclass.filters = copyFilters
        subclass.errors = copyErrors

        super
      end

      def copyRoutes
        newRoutes = {}
        @routes.each do |key, value|
          newRoutes[key] = value
        end
        newRoutes
      end

      def copyFilters
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

      def copyErrors
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

      def to_interface

        interface = Jetra::Interface.new(self)
        @routes.each_key do |route|
          eval("interface.define_singleton_method(route) do |params={}| ; @app.call(route, params) ; end ")
        end

        eval("interface.define_singleton_method(:method_missing) do |methodName, params={}| ; @app.call(methodName, params) ; end ")

        interface
      end
    end

    @routes         = {}
    @filters        = {:before => [], :after => []}
    @errors         = {}

    error do |boom|
      if boom.class == Jetra::NotFoundException
        trace = []
      else
        trace = boom.backtrace
      end
      response.body = {msg: "#{boom.class} - #{boom.message}", class: boom.class.to_s, route: request.route, params: params, trace: trace}
      halt
    end

  end
end