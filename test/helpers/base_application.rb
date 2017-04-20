libdir = File.expand_path("../../lib", __dir__)
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)

require "jetra"

class CustomTestException < Exception ; end

class CustomTestExceptionForHalt < Exception ; end

class BaseApplication < Jetra::Base

  def haltError(boom)
    @steps << "haltError"
    trace = ["#{boom.class} - #{boom.message}:", *boom.backtrace]
    #puts trace.join("\n\t")
    halt(msg: "got An Exception", trace: trace, route: request.route, params: params, steps: @steps)
  end

  def testRouteUsage
    @steps << "testRouteUsage"
    successInfoBody.merge({
      steps: @steps
    })
  end

  def testBeforeAndAfter
    @steps << "testBeforeAfter"
    successInfoBody.merge({
      steps: @steps
    })
  end

  def testStatus

    response.status = 135
    successInfoBody
  end

  def testInvoke1
    successInfoBody
  end

  def testInvoke2
    [194, successInfoBody]
  end

  def testHalt1
    response.body = successInfoBody
    halt
  end

  def testHalt2
    response.status = 333
    response.body = successInfoBody
    halt
  end

  def testHalt3
    halt successInfoBody
  end

  def testHalt4
    response.status = -33
    halt successInfoBody
  end

  def testHalt5
    halt [444, successInfoBody]
  end

  def testHalt6
    halt
  end

  def testRuntimeException
    @steps << "testRuntimeException"
    1/0
    @steps << "notRun"
  end

  def testCustomTestException
    @steps << "testCustomTestException"
    raise CustomTestException
    @steps << "notRun"
  end

  def testCustomTestExceptionForHalt
    @steps << "testCustomTestExceptionForHalt"
    raise CustomTestExceptionForHalt
    @steps << "notRun"
  end

  def testParams
    response.status = 391
    halt(msg:"got params #{params}")
  end

  def testEmptyAction
  end

  def successInfoBody
    {msg: "success"}
  end

  before do
    @steps = ["before1"]
  end

  before do
    @steps << "before2"
  end

  after do
    @steps << "after1"
  end

  after do
    @steps << "after2"
  end

  error do |boom|
    haltError(boom)
  end

  error CustomTestException do |boom|
    @steps << "customErrorBlock"
    haltError(boom)
  end

  error CustomTestExceptionForHalt do |boom|
    @steps << "customHaltErrorBlock"
    halt(msg: "got An CustomTestExceptionForHalt", steps: @steps)
  end

  route :testRouteUsageX do testRouteUsage end

  route :testBeforeAndAfter
  route :testStatus
  route :testInvoke1
  route :testInvoke2
  route :testHalt1
  route :testHalt2
  route :testHalt3
  route :testHalt4
  route :testHalt5
  route :testHalt6
  route :testRuntimeException
  route :testCustomTestException
  route :testCustomTestExceptionForHalt
  route :testParams
  route :testEmptyAction

end

