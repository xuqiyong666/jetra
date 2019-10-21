
require "jetra"

class FourApplication < Jetra::Base

  def invokeFour
    response.status = 8004
    successInfoBody
  end

  def successInfoBody
    {msg: "success"}
  end


  route :invokeFour

  route :invokeFourX   do invokeFour end

  error do |boom|
    halt(msg: "#{boom.class} - #{boom.message}", trace: boom.backtrace, route: request.route, params: params)
  end

end
