require_relative "helpers/second_extend_application"

require "test/unit"

require "jetra/builder"
require "jetra/middleware/validater"
require "jetra/middleware/sample"

builderAppication = Jetra::Builder.new do
  use Jetra::Middleware::Validater
  use Jetra::Middleware::Sample
  run SecondExtendApplication
end

BuilderApp = builderAppication.to_app

class TestBuilder < Test::Unit::TestCase

  def testParams
    params = {name: "jeffrey"}
    response = BuilderApp.testParams(params)

    assertResponseStatus(response, 391)

    assert(response.body[:msg] == "got params #{params}")
  end

  def testErrorParams
    params = "abc"
    response = BuilderApp.testParams(params)

    assertResponseStatus(response, 0)

    assert(response.body[:msg] == "Jetra::Middleware::Validater: params type miss match. excepted Hash, got #{params.class.to_s}")
  end

  def testStatus
    response = BuilderApp.testStatus

    assertSuccessMsg(response)
    assertResponseStatus(response, 135)
  end

  def testExtendRoute2
    response = BuilderApp.testExtendRoute2

    assertResponseStatus(response, 377)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testExtendRoute2", "after1", "after2", "after3", "after4"])
  end

  def testSecondExtendRoute2
    response = BuilderApp.testSecondExtendRoute2

    assertResponseStatus(response, 589)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testSecondExtendRoute2", "after1", "after2", "after3", "after4"])
  end

  def test_not_found

    param = {name: "jeffrey"}
    response = BuilderApp.aabbbccccdddeeffg(param)

    assertResponseStatus(response, 0)

    assert(response.body[:msg] == "got An Exception")

    assert(response.body[:params] == param)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "errorBlockInSecondExtendApplication", "errorBlockInExtendApplication", "haltError", "after1", "after2", "after3", "after4"])
  end

  def assertResponseStatus(response, status)
    assert(response.status == status)
  end

  def assertSuccessMsg(response)
    assert(response.body[:msg] == "success")
  end

end