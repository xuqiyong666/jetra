require "jetra/interface"

module Jetra

  class Combiner

    def initialize(&block)

      @leader = nil
      @routes = {}

      instance_eval(&block) if block_given?

      fail "missing mount statement" unless @leader
    end

    def call(route, params={})
      if app = @routes[route]
        app.call(route, params)
      else
        @leader.call(route, params)
      end
    end

    def routes
      @routes
    end

    def to_interface

      interface = Jetra::Interface.new(self)
      routes.each_key do |route|
        eval("interface.define_singleton_method(route) do |params={}| ; @app.call(route, params) ; end ")
      end

      eval("interface.define_singleton_method(:method_missing) do |method_name, params={}| ; @app.call(method_name, params) ; end ")

      interface
    end

    private 
    
    def mount(app)

      app.routes.each_key do |route|
        @routes[route] ||= app
      end

      @leader ||= app
    end

    def leader(app)
      @leader = app
    end

  end
end