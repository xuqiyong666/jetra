
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

RackApp = Jetra::RackAdapter.new(ApiInterface) do |route, params|
  puts "#{Time.now} route: #{route.inspect} params: #{params.inspect}"
end

Rack::Server.start(
  app: RackApp, :Port => 9292
)

