
class Example

  class << self

    attr_reader :prototype

    def get_prototype
      @prototype ||= Time.now.to_i
    end

    def call
      puts get_prototype
    end


  end


end

p Example.prototype

Example.call

sleep 2

Example.call

p Example.prototype
