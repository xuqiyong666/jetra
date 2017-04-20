libdir = File.expand_path("../../lib", __dir__)
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)

require "jetra"

require_relative "base_application"

class ExtendApplication < BaseApplication

  before do
    @steps << "before3"
  end

  after do
    @steps << "after3"
  end

  error do |boom|
    @steps << "errorBlockInExtendApplication"
  end

  error CustomTestException do |boom|
    @steps << "customErrorBlockInExtendApplication"
  end

  def testExtendRouteUsage
    @steps << "testExtendRouteUsage"
    response.status = 385
    successInfoBody.merge({
      steps: @steps
    })
  end

  def testExtendRoute2
    @steps << "testExtendRoute2"
    response.status = 377
    successInfoBody.merge({
      steps: @steps
    })
  end



  route :testExtendRouteUsageX do testExtendRouteUsage end

  route :testExtendRoute2

end

