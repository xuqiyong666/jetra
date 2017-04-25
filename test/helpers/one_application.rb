libdir = File.expand_path("../../lib", __dir__)
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)

require "jetra"

class OneApplication < Jetra::Base

  # before do 
  #   puts "OneApplication #{request.route} #{params.inspect}"
  # end

  def invokeOne

    p params[:test]
    response.status = 8001
    successInfoBody
  end

  def successInfoBody
    {msg: "success"}
  end

  route :invokeOne

  route :invokeOneX   do invokeOne end

  error do |boom|
    halt(msg: "#{boom.class} - #{boom.message}", route: request.route, params: params, trace: boom.backtrace)
  end

end
