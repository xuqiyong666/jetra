libdir = File.expand_path("../../lib", __dir__)
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)

require "jetra"

require_relative "extend_application"

class SecondExtendApplication < ExtendApplication

  before do
    @steps << "before4"
  end

  after do
    @steps << "after4"
  end

  error do |boom|
    @steps << "errorBlockInSecondExtendApplication"
  end

  error CustomTestException do |boom|
    @steps << "customErrorBlockInSecondExtendApplication"
  end

  def testSecondExtendRouteUsage
    @steps << "testSecondExtendRouteUsage"
    response.status = 482
    successInfoBody.merge({
      steps: @steps
    })
  end

  def testSecondExtendRoute2
    @steps << "testSecondExtendRoute2"
    response.status = 589
    successInfoBody.merge({
      steps: @steps
    })
  end


  route :testSecondExtendRouteUsageX do testSecondExtendRouteUsage end

  route :testSecondExtendRoute2

end

