# libdir = File.expand_path("../../lib", __dir__)
# .unshift libdir unless .include?(libdir)

require "jetra"

class EightApplication < Jetra::Base

  # before do 
  #   puts "EightApplication #{request.route} #{params.inspect}"
  # end

  def invokeEight
    response.status = 8008
    successInfoBody
  end

  def successInfoBody
    {msg: "success"}
  end


  route :invokeEight

  route :invokeEightX   do invokeEight end

  error do |boom|
    halt(msg: "#{boom.class} - #{boom.message}", trace: boom.backtrace, route: request.route, params: params)
  end

end
