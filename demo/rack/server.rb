
$LOAD_PATH.unshift File.expand_path("../../lib" , __dir__)

require "jetra"

require "jetra/adapter/rack"

class ApiInterface < Jetra::Base

  # error do
  #   halt "you got error"
  # end

  route :greeting do
    halt_success "hello, world!"
  end

  route :repeat do
    halt_success "you said `#{params[:msg] || "nothing"}`"
  end

  route :error do
    raise "some thing was wrong."
  end

end

RackApp = Jetra::RackAdapter.new(ApiInterface) do |request, params|

  # if you only want to accept post methods
  # if request.request_method != "POST"
  #   params[:request_path] = request.path_info
  #   request.path_info = "OnlyAcceptPostMethod"
  # end

end

Rack::Server.start(
  app: RackApp, :Port => 9292
)

