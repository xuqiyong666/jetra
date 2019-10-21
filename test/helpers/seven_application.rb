
require "jetra"

class SevenApplication < Jetra::Base

  def invokeSeven
    response.status = 8007
    successInfoBody
  end

  def successInfoBody
    {msg: "success"}
  end


  route :invokeSeven

  route :invokeSevenX   do invokeSeven end

  error do |boom|
    halt(msg: "#{boom.class} - #{boom.message}", trace: boom.backtrace, route: request.route, params: params)
  end

end
