module Jetra

  module Middleware

    #简单的中间件示例
    class Sample

      def initialize(app)
        @app = app
      end

      def call(route, params)

        #you can do something you like before call

        #puts "sample middleware call start.."

        response = @app.call(route, params)

        #puts "sample middleware call finish.."

        #you can do something you like after call

        response
      end

    end

  end
end