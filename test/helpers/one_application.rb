libdir = File.expand_path("../../lib", __dir__)

$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)

require "jetra"

class OneApplication < Jetra::Base

  def invokeOne
    response.status = 8001
    successInfoBody
  end

  def successInfoBody
    {msg: "success"}
  end

  route :invokeOne

  route :invokeOneX   do invokeOne end

  error do |boom|
    halt(msg: "#{boom.class} - #{boom.message}", trace: boom.backtrace, route: request.route, params: params)
  end

end
