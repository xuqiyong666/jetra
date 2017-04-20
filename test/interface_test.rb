require_relative "helpers/second_extend_application"

require "test/unit"

Application = SecondExtendApplication.to_app

class TestApplication < Test::Unit::TestCase

  def test_params

    param = {name: "jeffrey"}

    response = Application.testParams(param)

    assertResponseStatus(response, 391)

    assert(response.body[:msg] == "got params #{param}")
  end

  def test_not_found

    param = {name: "jeffrey"}
    response = Application.aabbbccccdddeeffg(param)

    assertResponseStatus(response, 0)

    assert(response.body[:msg] == "got An Exception")

    assert(response.body[:params] == param)

    assert(response.body[:steps] == ["before1", "before2", "before3", "before4", "errorBlockInSecondExtendApplication", "errorBlockInExtendApplication", "haltError", "after1", "after2", "after3", "after4"])
  end

  def testSecondExtendRouteUsageX
    response = Application.testSecondExtendRouteUsageX

    assertResponseStatus(response, 482)

    assertSuccessMsg(response)
  end

  def testSecondExtendRoute2
    response = Application.testSecondExtendRoute2

    assertResponseStatus(response, 589)

    assertSuccessMsg(response)
  end

  def assertResponseStatus(response, status)
    assert(response.status == status)
  end

  def assertSuccessMsg(response)
    assert(response.body[:msg] == "success")
  end

end

