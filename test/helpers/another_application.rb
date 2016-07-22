
require_relative "base_application"

class AnotherApplication < Jetra::Base

  def sayHelloX

    name = params[:name].to_s

    response.body = {msg: "hello, #{name}"}
    haltSuccess
  end

  def sayHi
    name = params[:name].to_s
    response.body = {msg: "hi, #{name}"}
    haltSuccess
  end

  def haltSuccess(status = 1)
    response.status = status
    halt
  end

  def haltFailure(status = -1)
    response.status = status
    halt
  end

  def haltError(boom)
    trace = ["#{boom.class} - #{boom.message}:", *boom.backtrace]
    #puts trace.join("\n\t")
    halt(msg: "got An Exception", trace: trace, route: request.route, params: params, steps: @steps)
  end


  error do |boom|
    haltError(boom)
  end

  route :sayHello do sayHelloX end

  route :sayHi

end
