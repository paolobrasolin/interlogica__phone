require "minitest/autorun"

require "phawn/phone_validator"

class TestPhoneValidator < Minitest::Test
  def test_missing_data
    output = Phawn::PhoneValidator.run("1234567890")
    assert_includes output, "TODO"
  end
end