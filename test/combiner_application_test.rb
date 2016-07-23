require_relative "helpers/second_extend_application"
require_relative "helpers/another_application"

require "test/unit"

require "jetra/combiner"

CombinerAppication = Jetra::Combiner.new do
  mount SecondExtendApplication
  mount AnotherApplication
end

CombinerInterface = CombinerAppication.to_interface

class TestCombinerApplication < Test::Unit::TestCase

  def testParams
    params = {name: "jeffrey"}
    response = CombinerAppication.call(:testParams, params)

    assertResponseStatus(response, 391)

    assert(response.body[:msg] == "got params #{params}")
  end

  def testStatus
    response = CombinerAppication.call(:testStatus)

    assertSuccessMsg(response)
    assertResponseStatus(response, 135)
  end

  def testExtendRoute2
    response = CombinerAppication.call(:testExtendRoute2)

    assertResponseStatus(response, 377)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testExtendRoute2", "after1", "after2", "after3", "after4"])
  end

  def testSecondExtendRoute2
    response = CombinerAppication.call(:testSecondExtendRoute2)

    assertResponseStatus(response, 589)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testSecondExtendRoute2", "after1", "after2", "after3", "after4"])
  end

  def testNotFound
    response = CombinerAppication.call(:testNotFoundRoutexxxxyyyyyzzzzzzyuxxidwd)

    assertResponseStatus(response, 0)
    
    assert(response.body[:msg] == "got An Exception")
  end

  def testSayHello

    params = {name: "jeffrey"}
    response = CombinerAppication.call(:sayHello, params)

    assertResponseStatus(response, 1)

    assert(response.body[:msg] == "hello, #{params[:name]}")
  end

  def testSayHi

    params = {name: "peter"}
    response = CombinerAppication.call(:sayHi, params)

    assertResponseStatus(response, 1)

    assert(response.body[:msg] == "hi, #{params[:name]}")
  end

  def testParamsWithInterface
    params = {name: "jeffrey"}
    response = CombinerInterface.testParams(params)

    assertResponseStatus(response, 391)

    assert(response.body[:msg] == "got params #{params}")
  end

  def testStatusWithInterface
    response = CombinerInterface.testStatus

    assertSuccessMsg(response)
    assertResponseStatus(response, 135)
  end

  def testExtendRoute2WithInterface
    response = CombinerInterface.testExtendRoute2

    assertResponseStatus(response, 377)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testExtendRoute2", "after1", "after2", "after3", "after4"])
  end

  def testSecondExtendRoute2WithInterface
    response = CombinerInterface.testSecondExtendRoute2

    assertResponseStatus(response, 589)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testSecondExtendRoute2", "after1", "after2", "after3", "after4"])
  end

  def testNotFoundWithInterface
    response = CombinerInterface.testNotFoundRoutexxxxyyyyyzzzzzzyuxxidwd

    assertResponseStatus(response, 0)
    
    assert(response.body[:msg] == "got An Exception")
  end

  def testSayHelloWithInterface

    params = {name: "jeffrey"}
    response = CombinerInterface.sayHello(params)

    assertResponseStatus(response, 1)

    assert(response.body[:msg] == "hello, #{params[:name]}")
  end

  def testSayHiWithInterface

    params = {name: "peter"}
    response = CombinerInterface.sayHi(params)

    assertResponseStatus(response, 1)

    assert(response.body[:msg] == "hi, #{params[:name]}")
  end

  def assertResponseStatus(response, status)
    assert(response.status == status)
  end

  def assertSuccessMsg(response)
    assert(response.body[:msg] == "success")
  end

end