require_relative "helpers/second_extend_application"
require_relative "helpers/another_application"

require "test/unit"

require "jetra/combiner"

CombinerApplication = Jetra::Combiner.new do
  mount SecondExtendApplication
  mount AnotherApplication
end

CombinerApp = CombinerApplication.to_app

class TestCombinerApp < Test::Unit::TestCase

  def testParams
    params = {name: "jeffrey"}
    response = CombinerApplication.call(:testParams, params)

    assertResponseStatus(response, 391)

    assert_equal(response.body[:msg], "got params #{params}")
  end

  def testStatus
    response = CombinerApplication.call(:testStatus)

    assertSuccessMsg(response)
    assertResponseStatus(response, 135)
  end

  def testExtendRoute2
    response = CombinerApplication.call(:testExtendRoute2)

    assertResponseStatus(response, 377)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testExtendRoute2", "after1", "after2", "after3", "after4"])
  end

  def testSecondExtendRoute2
    response = CombinerApplication.call(:testSecondExtendRoute2)

    assertResponseStatus(response, 589)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testSecondExtendRoute2", "after1", "after2", "after3", "after4"])
  end

  def testNotFound
    response = CombinerApplication.call(:testNotFoundRoutexxxxyyyyyzzzzzzyuxxidwd)

    assertResponseStatus(response, -1)
    
    assert_equal(response.body[:msg], "got An Exception")
  end

  def testSayHello

    params = {name: "jeffrey"}
    response = CombinerApplication.call(:sayHello, params)

    assertResponseStatus(response, 0)

    assert(response.body == "hello, #{params[:name]}")
  end

  def testSayHi

    params = {name: "peter"}
    response = CombinerApplication.call(:sayHi, params)

    assertResponseStatus(response, 0)

    assert(response.body == "hi, #{params[:name]}")
  end

  def testParamsWithApplication
    params = {name: "jeffrey"}
    response = CombinerApp.testParams(params)

    assertResponseStatus(response, 391)

    assert_equal(response.body[:msg], "got params #{params}")
  end

  def testStatusWithApplication
    response = CombinerApp.testStatus

    assertSuccessMsg(response)
    assertResponseStatus(response, 135)
  end

  def testExtendRoute2WithApplication
    response = CombinerApp.testExtendRoute2

    assertResponseStatus(response, 377)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testExtendRoute2", "after1", "after2", "after3", "after4"])
  end

  def testSecondExtendRoute2WithApplication
    response = CombinerApp.testSecondExtendRoute2

    assertResponseStatus(response, 589)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testSecondExtendRoute2", "after1", "after2", "after3", "after4"])
  end

  def testNotFoundWithApplication
    response = CombinerApp.testNotFoundRoutexxxxyyyyyzzzzzzyuxxidwd

    assertResponseStatus(response, -1)
    
    assert_equal(response.body[:msg], "got An Exception")
  end

  def testSayHelloWithApplication

    params = {name: "jeffrey"}
    response = CombinerApp.sayHello(params)

    assertResponseStatus(response, 0)

    assert(response.body == "hello, #{params[:name]}")
  end

  def testSayHiWithApplication

    params = {name: "peter"}
    response = CombinerApp.sayHi(params)

    assertResponseStatus(response, 0)

    assert(response.body == "hi, #{params[:name]}")
  end

  def assertResponseStatus(response, status)
    assert(response.status == status)
  end

  def assertSuccessMsg(response)
    assert(response.body[:msg] == "success")
  end

end