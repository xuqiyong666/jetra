libdir = File.expand_path("../../lib", __dir__)
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)

require "jetra"

class SixApplication < Jetra::Base

  def invokeSix
    response.status = 8006
    successInfoBody
  end

  def successInfoBody
    {msg: "success"}
  end


  route :invokeSix

  route :invokeSixX   do invokeSix end

  error do |boom|
    halt(msg: "#{boom.class} - #{boom.message}", trace: boom.backtrace, route: request.route, params: params)
  end

end
