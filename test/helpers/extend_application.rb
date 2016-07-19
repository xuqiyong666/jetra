
require_relative "base_application"

class ExtendApplication < BaseApplication

  before do
    @steps << "before3"
  end

  after do
    @steps << "after3"
  end

  not_found do
    @steps << "notFoundInExtendApplication"
  end

  error do |boom|
    @steps << "errorBlockInExtendApplication"
  end

  error CustomTestException do |boom|
    @steps << "customErrorBlockInExtendApplication"
  end

  def testExtendRouteUsage
    status(385)
    successInfoBody
  end

  def testExtendRoute2
    status(377)
    successInfoBody
  end



  route :testExtendRouteUsageX do testExtendRouteUsage end

  route :testExtendRoute2

end

