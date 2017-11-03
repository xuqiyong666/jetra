#用于封装基于jetra的thrift接口客户端，方便使用方调用

module Jetra

  class ThriftClient

    def initialize(thriftService, availableMethods)

      @thriftService = thriftService

      #方法列表是由使用方通过参数配置的。
      availableMethods.each do |methodName|
        add_client_method(methodName)
      end

    end

    def add_client_method(methodName)
      define_singleton_method(methodName) do |params={}|
        @thriftService.call(methodName, params)
      end
    end

  end

end