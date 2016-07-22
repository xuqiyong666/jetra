require "jetra/interface"


module Jetra

  class Combiner

    class << self

      def combine(&block)
        @use = []
        instance_eval(&block) if block_given?

        self
      end

      def call(route, params={})
        @app.call(route, params)
      end

      def to_interface

        interface = Jetra::Interface.new
        routes.each_key do |symbol|
          eval("interface.define_singleton_method(symbol) do |params={}| ; #{self.name}.call(symbol, params) ; end ")
        end

        eval("interface.define_singleton_method(:method_missing) do |method_name, params={}| ; #{self.name}.call(method_name, params) ; end ")

        interface
      end

      private 
      
      def mount(middleware)
        @use << proc { |app| middleware.new(app) }
      end

      def run(app)
        @run = app
      end

    end
  end
end