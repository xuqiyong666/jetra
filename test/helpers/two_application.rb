libdir = File.expand_path("../../lib", __dir__)

$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)

require "jetra"

class TwoApplication < Jetra::Base

  def invokeTwo
    response.status = 8002
    successInfoBody
  end

  def successInfoBody
    {msg: "success"}
  end

  route :invokeTwo

  route :invokeTwoX   do invokeTwo end

  error do |boom|
    halt(msg: "#{boom.class} - #{boom.message}", trace: boom.backtrace, route: request.route, params: params)
  end

end
