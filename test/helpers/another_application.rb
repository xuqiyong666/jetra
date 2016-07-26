libdir = File.expand_path("../../lib", __dir__)
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)

require "jetra"

class AnotherApplication < Jetra::Base

  def sayHelloX
    name = params[:name].to_s

    successResponse "hello, #{name}"
  end

  def sayHi
    name = params[:name].to_s

    successResponse "hi, #{name}"
  end

  route :sayHello do sayHelloX end

  route :sayHi

end
