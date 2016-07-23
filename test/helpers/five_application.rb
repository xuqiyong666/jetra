libdir = File.expand_path("../../lib", __dir__)

$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)

require "jetra"

class FiveApplication < Jetra::Base

  def invokeFive
    response.status = 8005
    successInfoBody
  end

  def successInfoBody
    {msg: "success"}
  end

  route :invokeFive

  route :invokeFiveX   do invokeFive end

  error do |boom|
    halt(msg: "#{boom.class} - #{boom.message}", trace: boom.backtrace, route: request.route, params: params)
  end

end
