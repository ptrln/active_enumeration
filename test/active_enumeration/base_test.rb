require 'test/unit'
require 'active_enumeration'
require 'test_enums'

class BaseTest < Test::Unit::TestCase

  def test_count
    assert_equal Region.count, 4
  end

  def test_find
    assert_not_nil Region.find(1)
  end

  def test_find_not_exists
    assert_nil Region.find(5)
  end

  def test_reponds_to_attributes
    region = Region.find(1)

    assert region.respond_to?(:name)
    assert region.respond_to?(:id)
    assert region.respond_to?(:area_name)
    assert region.respond_to?(:time_zone)
  end

  def test_attribute_values
    region = Region.find(1)

    assert_equal region.name, "Bay Area"
    assert_equal region.id, 1
    assert_equal region.area_name, "San Francisco Bay Area"
    assert_equal region.time_zone, "Pacific Time (US & Canada)"
  end

  def test_respond_to_symbol
    assert Region.find(1).respond_to?(:symbol)
  end

  def test_symbol_valume
    assert_equal Region.find(1).symbol, :bay_area
  end

  def test_no_symbol
    assert_nil Location.find(1).symbol
  end

  def test_enums_are_singleton
    assert_equal Region.find(1).object_id, Region.find(1).object_id
  end

  def test_groups
    assert_equal Region.live, [Region.find(1), Region.find(2)]
  end

  def test_responds_to_has_many
    assert Region.find(1).respond_to?(:locations)
  end

  def test_has_many
    assert_equal Region.find(1).locations, [Location.find(4), Location.find(5), Location.find(6)]
  end

  def test_where
    assert_equal Location.where(region_id: 3), Region.find(3).locations
  end

  def test_where_empty_result
    assert_equal Location.where(region_id: 10), []
  end

  def test_responds_to_belongs_to
    assert Location.find(1).respond_to?(:region)
  end

  def test_belongs_to
    assert_equal Location.find(1).region, Region.find(3)
  end

  def test_respond_to_enum_constants
    assert defined?(Region::bay_area)
    assert defined?(Region::los_angeles)
    assert defined?(Region::new_york)
    assert defined?(Region::chicago)

    assert_nil defined?(Location::BAY_AREA)
  end

  def test_enum_constants
    assert_equal Region::BAY_AREA, 1
    assert_equal Region::LOS_ANGELES, 2
    assert_equal Region::NEW_YORK, 3
    assert_equal Region::CHICAGO, 4
  end

  def test_respond_to_enum_retrieve_helper
    assert Region.respond_to?(:bay_area)
    assert Region.respond_to?(:los_angeles)
    assert Region.respond_to?(:new_york)
    assert Region.respond_to?(:chicago)

    assert_equal Location.respond_to?(:bay_area), false
  end

  def test_enum_retrieve_helper
    assert_equal Region.bay_area, Region.find(1)
  end

  def test_respond_to_enum_boolean_helper
    assert Region.find(1).respond_to?(:bay_area?)
    assert Region.find(1).respond_to?(:los_angeles?)
    assert Region.find(1).respond_to?(:new_york?)
    assert Region.find(1).respond_to?(:chicago?)

    assert_equal Location.find(1).respond_to?(:bay_area?), false
  end

  def test_enum_boolean_helper
    assert Region.find(1).bay_area?
    assert_equal Region.find(2).bay_area?, false
  end

  def test_all
    assert_equal Region.all, (1..4).map { |i| Region.find(i) }
  end

  def test_to_a
    assert_equal Region.to_a, Region.all.map { |r| [r.name, r.id] }
  end

  # TODO: write more tests
end