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

  def test_assign_better_enum
    @person.region = Region.find(3)
    assert_equal @person.region_id, 3
  end

  def test_assign_better_enums
    @person.previous_locations = @person.previous_locations << Location.find(4)
    assert_equal @person.previous_location_ids, [1, 2, 5, 4]
  end

  def test_clear_better_enums
    @person.previous_locations = []
    assert_equal @person.previous_location_ids, []
  end

  def test_assign_better_enum_id
    @person.region_id = 1
    assert_equal @person.region, Region.find(1)
  end

  def test_assign_better_enum_ids
    @person.previous_location_ids = [1, 4]
    assert_equal @person.previous_locations, [1, 4].map { |i| Location.find(i) }
  end

end