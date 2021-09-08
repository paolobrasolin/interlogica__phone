require "minitest/autorun"

require "phawn/number_params_parser"

module TestNumberParamsParser
  class ParametersPresence < Minitest::Test
    def setup
      @params = {}
    end

    def test_missing_data
      _, errors = Phawn::NumberParamsParser.run(@params)
      assert_includes errors, "data"
      assert_includes errors["data"], "parameter is mandatory"
    end
  end
end