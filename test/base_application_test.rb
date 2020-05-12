
require_relative "helpers/base_application"

require "test/unit"

class TestBaseApplication < Test::Unit::TestCase

  def testRouteUsage

    response = BaseApplication.call(:testRouteUsageX)

    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "testRouteUsage", "after1", "after2"])
  end

  def testBeforeAndAfter
    response = BaseApplication.call(:testBeforeAndAfter)

    assertSuccessMsg(response)
    assertResponseStatus(response, 0)

    assert(response.body[:steps] == ["before1", "before2", "testBeforeAfter", "after1", "after2"])
  end

  def testStatus
    response = BaseApplication.call(:testStatus)

    assertSuccessMsg(response)
    assertResponseStatus(response, 135)
  end

  def testHalt1
    response = BaseApplication.call(:testHalt1)

    assertSuccessMsg(response)
    assertResponseStatus(response, 0)
  end  

  def testHalt2
    response = BaseApplication.call(:testHalt2)

    assertSuccessMsg(response)
    assertResponseStatus(response, 333)
  end

  def testRuntimeException
    response = BaseApplication.call(:testRuntimeException)

    assert_equal(response.body[:msg], "got An Exception")
    assertResponseStatus(response, -1)

    assert(response.body[:steps] == ["before1", "before2", "testRuntimeException", "haltError", "after1", "after2"])
  end  

  def testCustomTestException
    response = BaseApplication.call(:testCustomTestException)

    assert_equal(response.body[:msg], "got An Exception")
    assertResponseStatus(response, -1)

    assert(response.body[:steps] == ["before1", "before2", "testCustomTestException", "customErrorBlock", "haltError", "after1", "after2"])
  end

  def testCustomTestExceptionForHalt
    response = BaseApplication.call(:testCustomTestExceptionForHalt)

    assert_equal(response.body[:msg], "got An CustomTestExceptionForHalt")
    assertResponseStatus(response, -1)

    assert(response.body[:steps] == ["before1", "before2", "testCustomTestExceptionForHalt", "customHaltErrorBlock", "after1", "after2"])
  end

  def testParams
    param = {name: "jeffrey"}
    response = BaseApplication.call(:testParams, param)

    assertResponseStatus(response, 391)

    assert_equal(response.body[:msg], "got params #{param}")
  end

  def testNotFound
    response = BaseApplication.call(:testNotFoundRoutexxxxyyyyyzzzzzzyuxxidwd)

    assertResponseStatus(response, -1)
    
    assert_equal(response.body[:msg], "got An Exception")

    assert(response.body[:steps] == ["before1", "before2", "haltError", "after1", "after2"])
  end

  def assertResponseStatus(response, status)
    assert(response.status == status)
  end

  def assertSuccessMsg(response)
    assert(response.body[:msg] == "success")
  end

end