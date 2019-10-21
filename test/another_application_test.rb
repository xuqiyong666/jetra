
require_relative "helpers/another_application"

require "test/unit"

AnotherApp = AnotherApplication.to_app

class TestAnotherApplication < Test::Unit::TestCase

  def testSayHello

    params = {name: "jeffrey"}
    response = AnotherApplication.call(:sayHello, params)

    assertResponseStatus(response, 0)

    assert(response.body == "hello, #{params[:name]}")
  end

  def testSayHi

    params = {name: "peter"}
    response = AnotherApplication.call(:sayHi, params)

    assertResponseStatus(response, 0)

    assert(response.body == "hi, #{params[:name]}")
  end

  def testNotFound
    response = AnotherApplication.call(:testNotFoundRoutexxxxyyyyyzzzzzzyuxxidwd, {xx: 123})

    assertResponseStatus(response, -1)
    
    assert(response.body[:class] == "Jetra::NotFoundException")

    assert(response.body[:msg] == "Jetra::NotFoundException - route not found")

    assert(response.body[:trace] == [])

  end

  def testFailureApi

    response = AnotherApplication.call(:failureApi)

    assertResponseStatus(response, -1)
    
    assert(response.body == "failureApi Message")
  end

  def testSayHelloWithApplication

    params = {name: "jeffrey"}
    response = AnotherApp.sayHello(params)

    assertResponseStatus(response, 0)

    assert(response.body == "hello, #{params[:name]}")
  end

  def testSayHiWithApplication

    params = {name: "peter"}
    response = AnotherApp.sayHi(params)

    assertResponseStatus(response, 0)

    assert(response.body == "hi, #{params[:name]}")
  end

  def testNotFoundWithApplication
    response = AnotherApp.testNotFoundRoutexxxxyyyyyzzzzzzyuxxidwd(xx: 123)

    assertResponseStatus(response, -1)
    
    assert(response.body[:class] == "Jetra::NotFoundException")

    assert(response.body[:msg] == "Jetra::NotFoundException - route not found")

    assert(response.body[:trace] == [])
  end

  def testFailureApiWithApplication

    response = AnotherApp.failureApi

    assertResponseStatus(response, -1)
    
    assert(response.body == "failureApi Message")
  end

  def assertResponseStatus(response, status)
    assert(response.status == status)
  end

  def assertSuccessMsg(response)
    assert(response.body[:msg] == "success")
  end

end