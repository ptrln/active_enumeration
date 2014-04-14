require 'test/unit'
require 'active_enumeration'
require 'test_models'

class ActiveEnumerationTest < Test::Unit::TestCase

  def setup
    @person = Person.new
  end

  def test_initialize
    assert_equal true, true
  end

  def test_has_active_enumeration_for
    assert_equal @person.region, Region.find(1)
    assert_equal @person.home_region, Region.find(2)
    assert_equal @person.last_location, Location.find(4)
  end

  def test_has_active_enumerations_for
    assert_equal @person.previous_locations, [1, 2, 5].map { |i| Location.find(i) }
  end

  def test_assign_active_enumeration
    @person.region = Region.find(3)
    assert_equal @person.region_id, 3
  end

  def test_assign_active_enumerations
    @person.previous_locations = @person.previous_locations << Location.find(4)
    assert_equal @person.previous_location_ids, [1, 2, 5, 4]
  end

  def test_clear_active_enumerations
    @person.previous_locations = []
    assert_equal @person.previous_location_ids, []
  end

  def test_assign_active_enumeration_id
    @person.region_id = 1
    assert_equal @person.region, Region.find(1)
  end

  def test_assign_active_enumeration_ids
    @person.previous_location_ids = [1, 4]
    assert_equal @person.previous_locations, [1, 4].map { |i| Location.find(i) }
  end

end