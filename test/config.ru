libdir = File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)

require_relative "helpers/one_application"
require_relative "helpers/two_application"
require_relative "helpers/three_application"
require_relative "helpers/four_application"
require_relative "helpers/five_application"
require_relative "helpers/six_application"
require_relative "helpers/seven_application"
require_relative "helpers/eight_application"

require "jetra/builder"
require "jetra/combiner"

require "jetra/middleware/validater"
require "jetra/middleware/sample"

require "jetra/adapter/rack"


combinerAppication = Jetra::Combiner.new do
  mount OneApplication
  mount TwoApplication
end

builderApplication = Jetra::Builder.new do
  use Jetra::Middleware::Validater
  use Jetra::Middleware::Sample
  run ThreeApplication
end

combiner2Application = Jetra::Combiner.new do
  mount builderApplication
  mount FourApplication
  mount FiveApplication
end

builder2Application = Jetra::Builder.new do
  use Jetra::Middleware::Validater
  use Jetra::Middleware::Sample
  run combiner2Application
end

combiner3Application = Jetra::Combiner.new do
  mount combinerAppication
  mount SixApplication
  mount SevenApplication
end

complexApplication = Jetra::Combiner.new do
  mount combiner3Application
  mount builder2Application
  mount EightApplication
end


RackApp = Jetra::RackAdapter.new(complexApplication) do |request, params|
  params[:appkey] = request.get_header("HTTP_APPKEY")
  params[:appsecret] = request.get_header("HTTP_APPSECRET")
end

use Rack::Deflater

map '/' do
  run RackApp
end


