module Jetra

  module Middleware

    #验证参数和返回值的基本类型
    class Validater

      def initialize(app)
        @app = app
      end

      def call(route, params)

        if !params.kind_of?(Hash)
          response = Jetra::Response.new
          response.status = 0
          response.body = {msg: "Jetra::Middleware::Validater: params type miss match. excepted Hash, got #{params.class.to_s}"}
        else
          response = @app.call(route, params)
          if !response.status.kind_of?(Integer)
            response.status = 0
            response.body = {msg: "Jetra::Middleware::Validater: response.status type miss match. excepted Integer, got #{response.status.class.to_s}"}
          else
            if !response.body.kind_of?(Hash)
              response.status = 0
              response.body = {msg: "Jetra::Middleware::Validater: response.body type miss match. excepted Hash, got #{response.body.class.to_s}"}
            end
          end
        end

        response
      end

    end

  end
end