
require "jetra"

class AnotherApplication < Jetra::Base

  error do |boom|
      boommsg = "#{boom.class} - #{boom.message}"

      if boom.class == Jetra::NotFoundException
        trace = []
      else
        trace = boom.backtrace
        trace.unshift boommsg
      end
      response.body = {msg: boommsg, class: boom.class.to_s, route: request.route, params: params, trace: trace}

      halt
  end

  def sayHello
    name = params[:name].to_s

    halt_success "hello, #{name}"
  end

  def sayHi
    name = params[:name].to_s

    halt_success "hi, #{name}"
  end

  def failureApi
    halt_failure "failureApi Message"
  end

  route "sayHello"

  route "sayHi"

  route "failureApi"

end
