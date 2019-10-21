# coding: utf-8

require_relative "helpers/second_extend_application"

require "test/unit"

require "jetra/builder"
require "jetra/middleware/validater"
require "jetra/middleware/sample"

BuilderAppication = Jetra::Builder.new do
  use Jetra::Middleware::Sample
  use Jetra::Middleware::Validater
  run SecondExtendApplication
end

params = "abc"
response = BuilderAppication.call(:testParams, params)

p response