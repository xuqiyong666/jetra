module Jetra

  class MiddlewareStack

    def initialize(&block)
      @use = []
      instance_eval(&block) if block_given?
    end

    def use
      
    end

    def run
      
    end

    def to_interface
      
    end

  end

end