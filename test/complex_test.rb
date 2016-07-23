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


ComplexInterface = ComplexApplication.to_interface

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


  def testInvokeOneWithInterface

    response = ComplexInterface.invokeOne

    assertResponseStatus(response, 8001)

    assertSuccessMsg(response)
  end

  def testInvokeOneXWithInterface

    response = ComplexInterface.invokeOneX

    assertResponseStatus(response, 8001)

    assertSuccessMsg(response)
  end

  def testInvokeTwoWithInterface

    response = ComplexInterface.invokeTwo

    assertResponseStatus(response, 8002)

    assertSuccessMsg(response)
  end

  def testInvokeTwoXWithInterface

    response = ComplexInterface.invokeTwoX

    assertResponseStatus(response, 8002)

    assertSuccessMsg(response)
  end

  def testInvokeThreeWithInterface

    response = ComplexInterface.invokeThree

    assertResponseStatus(response, 8003)

    assertSuccessMsg(response)
  end

  def testInvokeThreeXWithInterface

    response = ComplexInterface.invokeThreeX

    assertResponseStatus(response, 8003)

    assertSuccessMsg(response)
  end

  def testInvokeFourWithInterface

    response = ComplexInterface.invokeFour

    assertResponseStatus(response, 8004)

    assertSuccessMsg(response)
  end

  def testInvokeFourXWithInterface

    response = ComplexInterface.invokeFourX

    assertResponseStatus(response, 8004)

    assertSuccessMsg(response)
  end

  def testInvokeFiveWithInterface

    response = ComplexInterface.invokeFive

    assertResponseStatus(response, 8005)

    assertSuccessMsg(response)
  end

  def testInvokeFiveXWithInterface

    response = ComplexInterface.invokeFiveX

    assertResponseStatus(response, 8005)

    assertSuccessMsg(response)
  end

  def testInvokeSixWithInterface

    response = ComplexInterface.invokeSix

    assertResponseStatus(response, 8006)

    assertSuccessMsg(response)
  end

  def testInvokeSixXWithInterface

    response = ComplexInterface.invokeSixX

    assertResponseStatus(response, 8006)

    assertSuccessMsg(response)
  end

  def testInvokeSevenWithInterface

    response = ComplexInterface.invokeSeven

    assertResponseStatus(response, 8007)

    assertSuccessMsg(response)
  end

  def testInvokeSevenXWithInterface

    response = ComplexInterface.invokeSevenX

    assertResponseStatus(response, 8007)

    assertSuccessMsg(response)
  end

  def testInvokeEightWithInterface

    response = ComplexInterface.invokeEight

    assertResponseStatus(response, 8008)

    assertSuccessMsg(response)
  end

  def testInvokeEightXWithInterface

    response = ComplexInterface.invokeEightX

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
