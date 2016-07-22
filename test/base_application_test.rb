
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

   def testInvoke1
    response = BaseApplication.call(:testInvoke1)

    assertSuccessMsg(response)
    assertResponseStatus(response, 0)
  end
  
  def testInvoke2
    response = BaseApplication.call(:testInvoke2)

    assertSuccessMsg(response)
    assertResponseStatus(response, 194)
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

  def testHalt3
    response = BaseApplication.call(:testHalt3)

    assertSuccessMsg(response)
    assertResponseStatus(response, 0)
  end  

  def testHalt4
    response = BaseApplication.call(:testHalt4)

    assertSuccessMsg(response)
    assertResponseStatus(response, -33)
  end  

  def testHalt5
    response = BaseApplication.call(:testHalt5)

    assertSuccessMsg(response)
    assertResponseStatus(response, 444)
  end

  def testHalt6
    response = BaseApplication.call(:testHalt6)

    assert(response.body == nil)
    assertResponseStatus(response, 0)
  end  

  def testRuntimeException
    response = BaseApplication.call(:testRuntimeException)

    assert(response.body[:msg] == "got An Exception")
    assertResponseStatus(response, 0)

    assert(response.body[:steps] == ["before1", "before2", "testRuntimeException", "haltError", "after1", "after2"])
  end  

  def testCustomTestException
    response = BaseApplication.call(:testCustomTestException)

    assert(response.body[:msg] == "got An Exception")
    assertResponseStatus(response, 0)

    assert(response.body[:steps] == ["before1", "before2", "testCustomTestException", "customErrorBlock", "haltError", "after1", "after2"])
  end

  def testCustomTestExceptionForHalt
    response = BaseApplication.call(:testCustomTestExceptionForHalt)

    assert(response.body[:msg] == "got An CustomTestExceptionForHalt")
    assertResponseStatus(response, 0)

    assert(response.body[:steps] == ["before1", "before2", "testCustomTestExceptionForHalt", "customHaltErrorBlock", "after1", "after2"])
  end

  def testParams
    param = {name: "jeffrey"}
    response = BaseApplication.call(:testParams, param)

    assertResponseStatus(response, 391)

    assert(response.body[:msg] == "got params #{param}")
  end

  def testEmptyAction
    response = BaseApplication.call(:testEmptyAction)

    assert(response.body == nil)
    assertResponseStatus(response, 0)
  end  

  def testNotFound
    response = BaseApplication.call(:testNotFoundRoutexxxxyyyyyzzzzzzyuxxidwd)

    assertResponseStatus(response, 0)
    
    assert(response.body[:msg] == "got An Exception")

    assert(response.body[:steps] == ["before1", "before2", "haltError", "after1", "after2"])
  end

  def assertResponseStatus(response, status)
    assert(response.status == status)
  end

  def assertSuccessMsg(response)
    assert(response.body[:msg] == "success")
  end

end