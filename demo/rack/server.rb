
require "jetra"

require "jetra/adapter/rack"

class ApiInterface < Jetra::Base

  before do
    puts "#{Time.now} route: #{request.route.inspect} params: #{params.inspect}"
  end

  after do
    puts "#{Time.now} #{response.status} #{request.route.inspect} #{params.inspect}"
  end

  error do |boom| 
    
    response.status = 500

    puts ["#{Time.now} #{boom.class} - #{boom.message}:", *boom.backtrace].join("\n\t")

    raise boom
  end

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

RackApp = Jetra::RackAdapter.new(ApiInterface)

Rack::Server.start(
  app: RackApp, :Port => 9292
)

