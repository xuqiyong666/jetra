require "jetra/application"

module Jetra

  class Builder

    def initialize(&block)
      @use = []
      instance_eval(&block) if block_given?

      @app = build_app
    end

    def call(route, params={})
      @app.call(route, params)
    end

    def routes
      @run.routes
    end

    def to_app

      newApp = Jetra::Application.new(self)
      routes.each_key do |route|
        eval("newApp.define_singleton_method(route) do |params={}| ; @app.call(route, params) ; end ")
      end

      eval("newApp.define_singleton_method(:method_missing) do |methodName, params={}| ; @app.call(methodName, params) ; end ")

      newApp
    end

    private 
    
    def use(middleware)
      @use << proc { |app| middleware.new(app) }
    end

    def run(app)
      @run = app
    end

    def build_app
      app = @run
      fail "missing run statement" unless app
      app = @use.reverse.inject(app) { |a,e| e[a] }
      app
    end
  end
end