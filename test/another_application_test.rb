
require_relative "helpers/another_application"

require "test/unit"

AnotherInterface = AnotherApplication.to_interface

class TestAnotherApplication < Test::Unit::TestCase

  def testSayHello

    params = {name: "jeffrey"}
    response = AnotherApplication.call(:sayHello, params)

    assertResponseStatus(response, 1)

    assert(response.body[:msg] == "hello, #{params[:name]}")
  end

  def testSayHi

    params = {name: "peter"}
    response = AnotherApplication.call(:sayHi, params)

    assertResponseStatus(response, 1)

    assert(response.body[:msg] == "hi, #{params[:name]}")
  end

  def testNotFound
    response = AnotherApplication.call(:testNotFoundRoutexxxxyyyyyzzzzzzyuxxidwd, {xx: 123})

    assertResponseStatus(response, 0)
    
    assert(response.body[:class] == "Jetra::NotFoundException")

    assert(response.body[:msg] == "Jetra::NotFoundException - route not found")

    assert(response.body[:trace] == [])

  end

  def testFailureAip

    response = AnotherApplication.call(:failureApi)

    assertResponseStatus(response, -1)
    
    assert(response.body[:msg] == "failureApi Message")
  end

  def testSayHelloWithInterface

    params = {name: "jeffrey"}
    response = AnotherInterface.sayHello(params)

    assertResponseStatus(response, 1)

    assert(response.body[:msg] == "hello, #{params[:name]}")
  end

  def testSayHiWithInterface

    params = {name: "peter"}
    response = AnotherInterface.sayHi(params)

    assertResponseStatus(response, 1)

    assert(response.body[:msg] == "hi, #{params[:name]}")
  end

  def testNotFoundWithInterface
    response = AnotherInterface.testNotFoundRoutexxxxyyyyyzzzzzzyuxxidwd(xx: 123)

    assertResponseStatus(response, 0)
    
    assert(response.body[:class] == "Jetra::NotFoundException")

    assert(response.body[:msg] == "Jetra::NotFoundException - route not found")

    assert(response.body[:trace] == [])
  end

  def testFailureAipWithInterface

    response = AnotherInterface.failureApi

    assertResponseStatus(response, -1)
    
    assert(response.body[:msg] == "failureApi Message")
  end

  def assertResponseStatus(response, status)
    assert(response.status == status)
  end

  def assertSuccessMsg(response)
    assert(response.body[:msg] == "success")
  end

end