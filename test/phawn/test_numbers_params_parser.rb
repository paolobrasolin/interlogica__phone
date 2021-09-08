require "phawn/numbers_params_parser"
require "minitest/autorun"

module TestNumbersParamsParser
  class ParametersPresence < Minitest::Test
    def setup
      @params = {}
    end

    def test_missing_headers
      _, errors = Phawn::NumbersParamsParser.run(@params)
      assert_includes errors, "headers"
      assert_includes errors["headers"], "parameter is mandatory"
    end

    def test_missing_column
      _, errors = Phawn::NumbersParamsParser.run(@params)
      assert_includes errors, "column"
      assert_includes errors["column"], "parameter is mandatory"
    end

    def test_missing_data
      _, errors = Phawn::NumbersParamsParser.run(@params)
      assert_includes errors, "data"
      assert_includes errors["data"], "parameter is mandatory"
    end
  end

  class HeaderfullData < Minitest::Test
    def setup
      @params = { "headers" => "true", "column" => "number", "data" => { tempfile: <<~CSV } }
        id,number
        0,1234567890
        1,2345678901
        2,9012345678
      CSV
    end

    def test_invalid_headers
      @params["headers"] = "bork"
      _, errors = Phawn::NumbersParamsParser.run(@params)
      assert_includes errors, "headers"
      assert_includes errors["headers"], "allowed values: [true, false]"
    end

    def test_invalid_column
      @params["column"] = "bork"
      _, errors = Phawn::NumbersParamsParser.run(@params)
      assert_includes errors, "column"
      assert_includes errors["column"], "allowed values: [\"id\", \"number\"]"
    end

    def test_invalid_data
      @params["data"][:tempfile] = "\n\r"
      _, errors = Phawn::NumbersParamsParser.run(@params)
      assert_includes errors, "data"
      assert_includes errors["data"], "the CSV file is malformed"
    end

    def test_valid
      data, _ = Phawn::NumbersParamsParser.run(@params)
      assert_equal data, ["1234567890", "2345678901", "9012345678"]
    end
  end

  class HeaderlessData < Minitest::Test
    def setup
      @params = { "headers" => "false", "column" => "1", "data" => { tempfile: <<~CSV } }
        0,1234567890
        1,2345678901
        2,9012345678
      CSV
    end

    def test_invalid_headers
      @params["headers"] = "bork"
      _, errors = Phawn::NumbersParamsParser.run(@params)
      assert_includes errors, "headers"
      assert_includes errors["headers"], "allowed values: [true, false]"
    end

    def test_invalid_column
      @params["column"] = "2"
      _, errors = Phawn::NumbersParamsParser.run(@params)
      assert_includes errors, "column"
      assert_includes errors["column"], "allowed values: [0, 1]"
    end

    def test_invalid_data
      @params["data"][:tempfile] = "\n\r"
      _, errors = Phawn::NumbersParamsParser.run(@params)
      assert_includes errors, "data"
      assert_includes errors["data"], "the CSV file is malformed"
    end

    def test_valid
      data, _ = Phawn::NumbersParamsParser.run(@params)
      assert_equal data, ["1234567890", "2345678901", "9012345678"]
    end
  end
end