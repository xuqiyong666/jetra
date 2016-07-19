require_relative "helpers/extend_application"

require "test/unit"

class TestExtendApplication < Test::Unit::TestCase

  def testExtendRouteUsageX
    response = ExtendApplication.call(:testExtendRouteUsageX)

    assertResponseStatus(response, 385)
    assertSuccessMsg(response)
  end

  def testExtendRoute2
    response = ExtendApplication.call(:testExtendRoute2)

    assertResponseStatus(response, 377)
    assertSuccessMsg(response)
  end

  def testRouteUsage

    response = ExtendApplication.call(:testRouteUsageX)

    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "testRouteUsage", "after1", "after2", "after3"])
  end

  def testBeforeAndAfter
    response = ExtendApplication.call(:testBeforeAndAfter)

    assertSuccessMsg(response)
    assertResponseStatus(response, 0)

    assert(response.body[:steps] == ["before1", "before2", "before3", "testBeforeAfter", "after1", "after2", "after3"])
  end

  def testStatus
    response = ExtendApplication.call(:testStatus)

    assertSuccessMsg(response)
    assertResponseStatus(response, 135)
  end

   def testInvoke1
    response = ExtendApplication.call(:testInvoke1)

    assertSuccessMsg(response)
    assertResponseStatus(response, 0)
  end
  
  def testInvoke2
    response = ExtendApplication.call(:testInvoke2)

    assertSuccessMsg(response)
    assertResponseStatus(response, 194)
  end

  def testHalt1
    response = ExtendApplication.call(:testHalt1)

    assertSuccessMsg(response)
    assertResponseStatus(response, 0)
  end  

  def testHalt2
    response = ExtendApplication.call(:testHalt2)

    assertSuccessMsg(response)
    assertResponseStatus(response, 333)
  end  

  def testHalt3
    response = ExtendApplication.call(:testHalt3)

    assertSuccessMsg(response)
    assertResponseStatus(response, 0)
  end  

  def testHalt4
    response = ExtendApplication.call(:testHalt4)

    assertSuccessMsg(response)
    assertResponseStatus(response, -33)
  end  

  def testHalt5
    response = ExtendApplication.call(:testHalt5)

    assertSuccessMsg(response)
    assertResponseStatus(response, 444)
  end

  def testHalt6
    response = ExtendApplication.call(:testHalt6)

    assert(response.body == nil)
    assertResponseStatus(response, 0)
  end  

  def testRuntimeException
    response = ExtendApplication.call(:testRuntimeException)

    assert(response.body[:msg] == "got An Exception")
    assertResponseStatus(response, 0)

    assert(response.body[:steps] == ["before1", "before2", "before3", "testRuntimeException", "errorBlockInExtendApplication", "haltError", "after1", "after2", "after3"])
  end  

  def testCustomTestException
    response = ExtendApplication.call(:testCustomTestException)

    assert(response.body[:msg] == "got An Exception")
    assertResponseStatus(response, 0)

    assert(response.body[:steps] == ["before1", "before2", "before3", "testCustomTestException", "customErrorBlockInExtendApplication", "customErrorBlock", "haltError", "after1", "after2", "after3"])
  end

  def testCustomTestExceptionForHalt
    response = ExtendApplication.call(:testCustomTestExceptionForHalt)

    assert(response.body[:msg] == "got An CustomTestExceptionForHalt")
    assertResponseStatus(response, 0)

    assert(response.body[:steps] == ["before1", "before2", "before3", "testCustomTestExceptionForHalt", "customHaltErrorBlock", "after1", "after2", "after3"])
  end

  def testEmptyAction
    response = ExtendApplication.call(:testEmptyAction)

    assert(response.body == nil)
    assertResponseStatus(response, 0)
  end  

  def testNotFound
    response = ExtendApplication.call(:testNotFoundRoutexxxxyyyyyzzzzzzyuxxidwd)

    assert(response.body[:msg] == "route Not Found")
    assertResponseStatus(response, 0)

    assert(response.body[:steps] == ["before1", "before2", "before3", "notFoundInExtendApplication", "notFoundInBaseApplication", "after1", "after2", "after3"])
  end

  def assertResponseStatus(response, status)
    assert(response.status == status)
  end

  def assertSuccessMsg(response)
    assert(response.body[:msg] == "success")
  end

end