class Person
  extend ActiveEnumeration

  attr_accessor :region_id, :home_region_id, :location_id, :previous_location_ids

  has_active_enumeration_for :region
  has_active_enumeration_for :home_region, class_name: "Region"
  has_active_enumeration_for :last_location, class_name: "Location", foreign_key: "location_id"
  has_active_enumerations_for :previous_locations, class_name: "Location"

  def initialize
    @region_id = 1
    @home_region_id = 2
    @location_id = 4
    @previous_location_ids = [1, 2, 5]
  end

end