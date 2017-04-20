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

require "test/unit"

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

ComplexApplication = Jetra::Combiner.new do
  mount combiner3Application
  mount builder2Application
  mount EightApplication
end


ComplexApp = ComplexApplication.to_app

class TestComplex < Test::Unit::TestCase

  def testInvokeOne

    response = ComplexApplication.call(:invokeOne)

    assertResponseStatus(response, 8001)

    assertSuccessMsg(response)
  end

  def testInvokeOneX

    response = ComplexApplication.call(:invokeOneX)

    assertResponseStatus(response, 8001)

    assertSuccessMsg(response)
  end

  def testInvokeTwo

    response = ComplexApplication.call(:invokeTwo)

    assertResponseStatus(response, 8002)

    assertSuccessMsg(response)
  end

  def testInvokeTwoX

    response = ComplexApplication.call(:invokeTwoX)

    assertResponseStatus(response, 8002)

    assertSuccessMsg(response)
  end

  def testInvokeThree

    response = ComplexApplication.call(:invokeThree)

    assertResponseStatus(response, 8003)

    assertSuccessMsg(response)
  end

  def testInvokeThreeX

    response = ComplexApplication.call(:invokeThreeX)

    assertResponseStatus(response, 8003)

    assertSuccessMsg(response)
  end

  def testInvokeFour

    response = ComplexApplication.call(:invokeFour)

    assertResponseStatus(response, 8004)

    assertSuccessMsg(response)
  end

  def testInvokeFourX

    response = ComplexApplication.call(:invokeFourX)

    assertResponseStatus(response, 8004)

    assertSuccessMsg(response)
  end

  def testInvokeFive

    response = ComplexApplication.call(:invokeFive)

    assertResponseStatus(response, 8005)

    assertSuccessMsg(response)
  end

  def testInvokeFiveX

    response = ComplexApplication.call(:invokeFiveX)

    assertResponseStatus(response, 8005)

    assertSuccessMsg(response)
  end

  def testInvokeSix

    response = ComplexApplication.call(:invokeSix)

    assertResponseStatus(response, 8006)

    assertSuccessMsg(response)
  end

  def testInvokeSixX

    response = ComplexApplication.call(:invokeSixX)

    assertResponseStatus(response, 8006)

    assertSuccessMsg(response)
  end

  def testInvokeSeven

    response = ComplexApplication.call(:invokeSeven)

    assertResponseStatus(response, 8007)

    assertSuccessMsg(response)
  end

  def testInvokeSevenX

    response = ComplexApplication.call(:invokeSevenX)

    assertResponseStatus(response, 8007)

    assertSuccessMsg(response)
  end

  def testInvokeEight

    response = ComplexApplication.call(:invokeEight)

    assertResponseStatus(response, 8008)

    assertSuccessMsg(response)
  end

  def testInvokeEightX

    response = ComplexApplication.call(:invokeEightX)

    assertResponseStatus(response, 8008)

    assertSuccessMsg(response)
  end


  def testInvokeOneWithApplication

    response = ComplexApp.invokeOne

    assertResponseStatus(response, 8001)

    assertSuccessMsg(response)
  end

  def testInvokeOneXWithApplication

    response = ComplexApp.invokeOneX

    assertResponseStatus(response, 8001)

    assertSuccessMsg(response)
  end

  def testInvokeTwoWithApplication

    response = ComplexApp.invokeTwo

    assertResponseStatus(response, 8002)

    assertSuccessMsg(response)
  end

  def testInvokeTwoXWithApplication

    response = ComplexApp.invokeTwoX

    assertResponseStatus(response, 8002)

    assertSuccessMsg(response)
  end

  def testInvokeThreeWithApplication

    response = ComplexApp.invokeThree

    assertResponseStatus(response, 8003)

    assertSuccessMsg(response)
  end

  def testInvokeThreeXWithApplication

    response = ComplexApp.invokeThreeX

    assertResponseStatus(response, 8003)

    assertSuccessMsg(response)
  end

  def testInvokeFourWithApplication

    response = ComplexApp.invokeFour

    assertResponseStatus(response, 8004)

    assertSuccessMsg(response)
  end

  def testInvokeFourXWithApplication

    response = ComplexApp.invokeFourX

    assertResponseStatus(response, 8004)

    assertSuccessMsg(response)
  end

  def testInvokeFiveWithApplication

    response = ComplexApp.invokeFive

    assertResponseStatus(response, 8005)

    assertSuccessMsg(response)
  end

  def testInvokeFiveXWithApplication

    response = ComplexApp.invokeFiveX

    assertResponseStatus(response, 8005)

    assertSuccessMsg(response)
  end

  def testInvokeSixWithApplication

    response = ComplexApp.invokeSix

    assertResponseStatus(response, 8006)

    assertSuccessMsg(response)
  end

  def testInvokeSixXWithApplication

    response = ComplexApp.invokeSixX

    assertResponseStatus(response, 8006)

    assertSuccessMsg(response)
  end

  def testInvokeSevenWithApplication

    response = ComplexApp.invokeSeven

    assertResponseStatus(response, 8007)

    assertSuccessMsg(response)
  end

  def testInvokeSevenXWithApplication

    response = ComplexApp.invokeSevenX

    assertResponseStatus(response, 8007)

    assertSuccessMsg(response)
  end

  def testInvokeEightWithApplication

    response = ComplexApp.invokeEight

    assertResponseStatus(response, 8008)

    assertSuccessMsg(response)
  end

  def testInvokeEightXWithApplication

    response = ComplexApp.invokeEightX

    assertResponseStatus(response, 8008)

    assertSuccessMsg(response)
  end


  def assertResponseStatus(response, status)
    assert(response.status == status)
  end

  def assertSuccessMsg(response)
    assert(response.body[:msg] == "success")
  end


end
