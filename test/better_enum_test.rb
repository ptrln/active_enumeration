require 'test/unit'
require 'better_enum'
require 'test_models'

class BetterEnumTest < Test::Unit::TestCase

  def setup
    @person = Person.new
  end

  def test_initialize
    assert_equal true, true
  end

  def test_has_better_enum_for
    assert_equal @person.region, Region.find(1)
    assert_equal @person.home_region, Region.find(2)
    assert_equal @person.last_location, Location.find(4)
  end

  def test_has_better_enums_for
    assert_equal @person.previous_locations, [1, 2, 5].map { |i| Location.find(i) }
  end

  # no tests yet...
  # TODO: write some tests
end