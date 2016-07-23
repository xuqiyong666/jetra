require "jetra/interface"

module Jetra

  class Builder

    def initialize(&block)
      @use = []
      instance_eval(&block) if block_given?

      @app = to_app
    end

    def call(route, params={})
      @app.call(route, params)
    end

    def routes
      @run.routes
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
    
    def use(middleware)
      @use << proc { |app| middleware.new(app) }
    end

    def run(app)
      @run = app
    end

    def to_app
      app = @run
      fail "missing run statement" unless app
      app = @use.reverse.inject(app) { |a,e| e[a] }
      app
    end
  end
end