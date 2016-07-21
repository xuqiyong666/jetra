require "jetra/interface"

module Jetra

  class Builder

    class << self

      def build(&block)
        @use = []
        instance_eval(&block) if block_given?

        @app = to_app

        self
      end

      def call(route, params={})
        @app.call(route, params)
      end

      def to_interface

        interface = Jetra::Interface.new
        @run.routes.each_key do |symbol|
          eval("interface.define_singleton_method(symbol) do |params={}| ; #{self.name}.call(symbol, params) ; end ")
        end

        eval("interface.define_singleton_method(:method_missing) do |method_name, params={}| ; #{self.name}.call(method_name, params) ; end ")

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
end