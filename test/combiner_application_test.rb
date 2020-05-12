require_relative "helpers/base_application"
require_relative "helpers/another_application"

require "test/unit"

require "jetra/combiner"

CombinerApplication = Jetra::Combiner.new do
  mount BaseApplication
  mount AnotherApplication
end

CombinerApp = CombinerApplication.to_app

class TestCombinerApp < Test::Unit::TestCase

  def testSayHello
    params = {name: "abc"}
    response = CombinerApplication.call(:sayHello, params)

    p "testSayHello", response

    assert_equal(response.status, 0)

  end

end