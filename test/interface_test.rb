require_relative "helpers/second_extend_application"

require "test/unit"

Interface = SecondExtendApplication.to_interface

class TestInterface < Test::Unit::TestCase

  def test_params

    p Interface.testParams(name: "jeffrey")
  end

  def test_not_found

    p Interface.aabbbccccdddeeffg(name: "jeffrey")
  end

end

