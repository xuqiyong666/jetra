module Jetra

  class Builder

    def initialize(&block)
      @use = []
      instance_eval(&block) if block_given?
    end

    def to_interface
      
    end

  end

end