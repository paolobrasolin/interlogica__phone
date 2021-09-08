require "minitest/autorun"

require "phawn/phone"

class TestPhone < Minitest::Test
  def test_canonical_number
    phone = Phawn::Phone.new("27123456789")
    assert_equal phone.origin, "27123456789"
    assert_equal phone.output, "27123456789"
    assert_equal phone.status, :VALID
    assert_equal phone.change, []
  end

  def test_canonical_number_with_whitespace
    phone = Phawn::Phone.new(" 27 123  456 789 ")
    assert_equal phone.origin, " 27 123  456 789 "
    assert_equal phone.output, "27123456789"
    assert_equal phone.status, :FIXED
    assert_equal phone.change, [:WHITESPACE]
  end

  def test_short_number
    phone = Phawn::Phone.new("123456789")
    assert_equal phone.origin, "123456789"
    assert_equal phone.output, "27123456789"
    assert_equal phone.status, :FIXED
    assert_equal phone.change, [:PREFIX]
  end

  def test_short_number_with_whitespace
    phone = Phawn::Phone.new(" 123  456 789 ")
    assert_equal phone.origin, " 123  456 789 "
    assert_equal phone.output, "27123456789"
    assert_equal phone.status, :FIXED
    assert_equal phone.change, [:WHITESPACE, :PREFIX]
  end

  def test_long_number
    phone = Phawn::Phone.new("+27123456789")
    assert_equal phone.origin, "+27123456789"
    assert_equal phone.output, "27123456789"
    assert_equal phone.status, :FIXED
    assert_equal phone.change, [:PREFIX]
  end

  def test_long_number_with_whitespace
    phone = Phawn::Phone.new(" +27 123  456 789 ")
    assert_equal phone.origin, " +27 123  456 789 "
    assert_equal phone.output, "27123456789"
    assert_equal phone.status, :FIXED
    assert_equal phone.change, [:WHITESPACE, :PREFIX]
  end

  def test_bogus_number
    phone = Phawn::Phone.new("1234567890")
    assert_equal phone.origin, "1234567890"
    assert_nil phone.output
    assert_equal phone.status, :BOGUS
    assert_nil phone.change
  end
end