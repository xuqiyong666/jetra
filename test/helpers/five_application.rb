
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
