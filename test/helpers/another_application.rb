
require "jetra"

class AnotherApplication < Jetra::Base

  def sayHelloX
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

  route :sayHello do sayHelloX end

  route :sayHi

  route :failureApi

end
