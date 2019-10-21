require_relative "helpers/second_extend_application"

require "test/unit"

class TestSecondExtendApplication < Test::Unit::TestCase

  def testSecondExtendRouteUsageX
    response = SecondExtendApplication.call(:testSecondExtendRouteUsageX)

    assertResponseStatus(response, 482)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testSecondExtendRouteUsage", "after1", "after2", "after3", "after4"])
  end

  def testSecondExtendRoute2
    response = SecondExtendApplication.call(:testSecondExtendRoute2)

    assertResponseStatus(response, 589)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testSecondExtendRoute2", "after1", "after2", "after3", "after4"])
  end


  def testExtendRouteUsageX
    response = SecondExtendApplication.call(:testExtendRouteUsageX)

    assertResponseStatus(response, 385)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testExtendRouteUsage", "after1", "after2", "after3", "after4"])
  end

  def testExtendRoute2
    response = SecondExtendApplication.call(:testExtendRoute2)

    assertResponseStatus(response, 377)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testExtendRoute2", "after1", "after2", "after3", "after4"])
  end

  def testRouteUsage

    response = SecondExtendApplication.call(:testRouteUsageX)

    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testRouteUsage", "after1", "after2", "after3", "after4"])
  end

  def testBeforeAndAfter
    response = SecondExtendApplication.call(:testBeforeAndAfter)

    assertSuccessMsg(response)
    assertResponseStatus(response, -1)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testBeforeAfter", "after1", "after2", "after3", "after4"])
  end

  def testStatus
    response = SecondExtendApplication.call(:testStatus)

    assertSuccessMsg(response)
    assertResponseStatus(response, 135)
  end

   def testInvoke1
    response = SecondExtendApplication.call(:testInvoke1)

    assertSuccessMsg(response)
    assertResponseStatus(response, -1)
  end
  
  def testInvoke2
    response = SecondExtendApplication.call(:testInvoke2)

    assertSuccessMsg(response)
    assertResponseStatus(response, 194)
  end

  def testHalt1
    response = SecondExtendApplication.call(:testHalt1)

    assertSuccessMsg(response)
    assertResponseStatus(response, -1)
  end  

  def testHalt2
    response = SecondExtendApplication.call(:testHalt2)

    assertSuccessMsg(response)
    assertResponseStatus(response, 333)
  end  

  def testHalt3
    response = SecondExtendApplication.call(:testHalt3)

    assertSuccessMsg(response)
    assertResponseStatus(response, -1)
  end  

  def testHalt4
    response = SecondExtendApplication.call(:testHalt4)

    assertSuccessMsg(response)
    assertResponseStatus(response, -33)
  end  

  def testHalt5
    response = SecondExtendApplication.call(:testHalt5)

    assertSuccessMsg(response)
    assertResponseStatus(response, 444)
  end

  def testHalt6
    response = SecondExtendApplication.call(:testHalt6)

    assert_equal(response.body, "")
    assertResponseStatus(response, -1)
  end

  def testRuntimeException
    response = SecondExtendApplication.call(:testRuntimeException)

    assert_equal(response.body[:msg], "got An Exception")
    assertResponseStatus(response, -1)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testRuntimeException", "errorBlockInSecondExtendApplication", "errorBlockInExtendApplication", "haltError", "after1", "after2", "after3", "after4"])
  end  

  def testCustomTestException
    response = SecondExtendApplication.call(:testCustomTestException)

    assert_equal(response.body[:msg], "got An Exception")
    assertResponseStatus(response, -1)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testCustomTestException", "customErrorBlockInSecondExtendApplication", "customErrorBlockInExtendApplication", "customErrorBlock", "haltError", "after1", "after2", "after3", "after4"])
  end

  def testCustomTestExceptionForHalt
    response = SecondExtendApplication.call(:testCustomTestExceptionForHalt)

    assert_equal(response.body[:msg], "got An CustomTestExceptionForHalt")
    assertResponseStatus(response, -1)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testCustomTestExceptionForHalt", "customHaltErrorBlock", "after1", "after2", "after3", "after4"])
  end

  def testParams
    param = {name: "jeffrey"}
    response = SecondExtendApplication.call(:testParams, param)

    assertResponseStatus(response, 391)

    assert_equal(response.body[:msg], "got params #{param}")
  end

  def testEmptyAction
    response = SecondExtendApplication.call(:testEmptyAction)

    assert_equal(response.body, "")
    assertResponseStatus(response, -1)
  end  

  def testNotFound
    response = SecondExtendApplication.call(:testNotFoundRoutexxxxyyyyyzzzzzzyuxxidwd)

    assertResponseStatus(response, -1)

    assert_equal(response.body[:msg], "got An Exception")

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "errorBlockInSecondExtendApplication", "errorBlockInExtendApplication", "haltError", "after1", "after2", "after3", "after4"])
  end

  def assertResponseStatus(response, status)
    assert(response.status == status)
  end

  def assertSuccessMsg(response)
    assert(response.body[:msg] == "success")
  end

end