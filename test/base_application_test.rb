
require_relative "helpers/base_application"

require "test/unit"

class TestBaseApplication < Test::Unit::TestCase

  def app
    BaseApplication
  end

  def testRouteUsage

    response = app.call(:testRouteUsageX)

    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "testRouteUsage", "after1", "after2"])
  end

  def testBeforeAndAfter
    response = app.call(:testBeforeAndAfter)

    assertSuccessMsg(response)
    assertResponseStatus(response, 0)

    assert(response.body[:steps] == ["before1", "before2", "testBeforeAfter", "after1", "after2"])
  end

  def testStatus
    response = app.call(:testStatus)

    assertSuccessMsg(response)
    assertResponseStatus(response, 135)
  end

   def testInvoke1
    response = app.call(:testInvoke1)

    assertSuccessMsg(response)
    assertResponseStatus(response, 0)
  end
  
  def testInvoke2
    response = app.call(:testInvoke2)

    assertSuccessMsg(response)
    assertResponseStatus(response, 194)
  end

  def testHalt1
    response = app.call(:testHalt1)

    assertSuccessMsg(response)
    assertResponseStatus(response, 0)
  end  

  def testHalt2
    response = app.call(:testHalt2)

    assertSuccessMsg(response)
    assertResponseStatus(response, 333)
  end  

  def testHalt3
    response = app.call(:testHalt3)

    assertSuccessMsg(response)
    assertResponseStatus(response, 0)
  end  

  def testHalt4
    response = app.call(:testHalt4)

    assertSuccessMsg(response)
    assertResponseStatus(response, -33)
  end  

  def testHalt5
    response = app.call(:testHalt5)

    assertSuccessMsg(response)
    assertResponseStatus(response, 444)
  end

  def testHalt6
    response = app.call(:testHalt6)

    assert(response.body == nil)
    assertResponseStatus(response, 0)
  end  

  def testRuntimeException
    response = app.call(:testRuntimeException)

    assert(response.body[:msg] == "got An Exception")
    assertResponseStatus(response, 0)

    assert(response.body[:steps] == ["before1", "before2", "testRuntimeException", "haltError", "after1", "after2"])
  end  

  def testCustomTestException
    response = app.call(:testCustomTestException)

    assert(response.body[:msg] == "got An Exception")
    assertResponseStatus(response, 0)

    assert(response.body[:steps] == ["before1", "before2", "testCustomTestException", "customErrorBlock", "haltError", "after1", "after2"])
  end

  def testCustomTestExceptionForHalt
    response = app.call(:testCustomTestExceptionForHalt)

    assert(response.body[:msg] == "got An CustomTestExceptionForHalt")
    assertResponseStatus(response, 0)

    assert(response.body[:steps] == ["before1", "before2", "testCustomTestExceptionForHalt", "customHaltErrorBlock", "after1", "after2"])
  end

  def testEmptyAction
    response = app.call(:testEmptyAction)

    assert(response.body == nil)
    assertResponseStatus(response, 0)
  end  

  def testNotFound
    response = app.call(:testNotFoundRoutexxxxyyyyyzzzzzzyuxxidwd)

    assert(response.body[:msg] == "route Not Found")
    assertResponseStatus(response, 0)

    assert(response.body[:steps] == ["before1", "before2", "notFoundInBaseApplication", "after1", "after2"])
  end

  def assertResponseStatus(response, status)
    assert(response.status == status)
  end

  def assertSuccessMsg(response)
    assert(response.body[:msg] == "success")
  end

end