
require_relative "extend_application"

class SecondExtendApplication < ExtendApplication

  before do
    @steps << "before4"
  end

  after do
    @steps << "after4"
  end

  not_found do
    @steps << "notFoundInSecondExtendApplication"
  end

  error do |boom|
    @steps << "errorBlockInSecondExtendApplication"
  end

  error CustomTestException do |boom|
    @steps << "customErrorBlockInSecondExtendApplication"
  end

  def testSecondExtendRouteUsage
    status(482)
    successInfoBody
  end

  def testSecondExtendRoute2
    status(589)
    successInfoBody
  end


  route :testSecondExtendRouteUsageX do testSecondExtendRouteUsage end

  route :testSecondExtendRoute2

end

