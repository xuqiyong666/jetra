require_relative "helpers/second_extend_application"

require "test/unit"

require "jetra/builder"
require "jetra/middleware/validater"
require "jetra/middleware/sample"

BuilderAppication = Jetra::Builder.build do
  use Jetra::Middleware::Validater
  use Jetra::Middleware::Sample
  run SecondExtendApplication
end

BuilderInterface = BuilderAppication.to_interface

class TestBuilder < Test::Unit::TestCase

  def testParams
    params = {name: "jeffrey"}
    response = BuilderInterface.testParams(params)

    assertResponseStatus(response, 391)

    assert(response.body[:msg] == "got params #{params}")
  end

  def testErrorParams
    params = "abc"
    response = BuilderInterface.testParams(params)

    assertResponseStatus(response, 0)

    assert(response.body[:msg] == "Jetra::Middleware::Validater: params type miss match. excepted Hash, got #{params.class.to_s}")
  end

  def testStatus
    response = BuilderInterface.testStatus

    assertSuccessMsg(response)
    assertResponseStatus(response, 135)
  end

  def testExtendRoute2
    response = BuilderInterface.testExtendRoute2

    assertResponseStatus(response, 377)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testExtendRoute2", "after1", "after2", "after3", "after4"])
  end

  def testSecondExtendRoute2
    response = BuilderInterface.testSecondExtendRoute2

    assertResponseStatus(response, 589)
    assertSuccessMsg(response)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "testSecondExtendRoute2", "after1", "after2", "after3", "after4"])
  end

  def assertResponseStatus(response, status)
    assert(response.status == status)
  end

  def assertSuccessMsg(response)
    assert(response.body[:msg] == "success")
  end

end