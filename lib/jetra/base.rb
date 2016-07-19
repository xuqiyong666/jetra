

module Jetra

  class NotFoundException < Exception ; end

  class Halt ; end

  class Request

    attr_accessor :method_name, :params

    def initialize(method_name, params)
      @method_name = method_name || ""
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

    def call(method_name, params)
      dup.call!(method_name, params)
    end

    def call!(method_name, params)

      @env = {}

      @request  = Request.new(method_name, params)
      @response = Response.new

      @params   = indifferent_params(@request.params)

      invoke { dispatch! }

      @response.finish
    end

    def current_class
      self.class
    end

    def status(value = nil)
      if value
        @response.status = value
      else
        @response.status
      end
    end

    def body(value = nil)
      if value
        @response.body = value
      else
        @response.body
      end
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
        status(res.shift)
        body(res.shift)
      else
        body(res)
      end
      nil
    end

    def dispatch!
      filter! :before
      route!
    rescue ::Exception => boom
      handle_exception!(boom)
    ensure
      begin
        filter! :after
      rescue ::Exception => boom
        handle_exception!(boom) unless @env["jetra.error"]
      end
    end

    def handle_exception!(boom)
      @env['jetra.error'] = boom

      status(0)

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

      if block = current_class.routes[@request.method_name.to_sym]
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
      raise NotFoundException
    end

    class << self

      attr_accessor :routes, :filters, :errors

      def prototype
        @prototype ||= new
      end

      def call(method_name, params=nil)
        prototype.call(method_name, params)
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

      def route(method_name, &block)
        block ||= Proc.new { method(method_name).call }
        @routes[method_name] = compile!(&block)
      end

      def error(*codes, &block)
        codes = codes.map { |c| Array(c) }.flatten
        codes << Exception if codes.empty?
        codes.each { |c| (@errors[c] ||= []) << compile!(&block) }
      end

      def not_found(&block)
        error(NotFoundException, &block)
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

        super
      end

    end

    @routes         = {}
    @filters        = {:before => [], :after => []}
    @errors         = {}
  end
end