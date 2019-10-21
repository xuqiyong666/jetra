
require "jetra"

class ThreeApplication < Jetra::Base

  def invokeThree
    response.status = 8003
    successInfoBody
  end

  def successInfoBody
    {msg: "success"}
  end

  
  route :invokeThree

  route :invokeThreeX   do invokeThree end

  error do |boom|
    halt(msg: "#{boom.class} - #{boom.message}", trace: boom.backtrace, route: request.route, params: params)
  end

end
