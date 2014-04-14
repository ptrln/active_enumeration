class Person
  extend BetterEnum

  attr_accessor :region_id, :home_region_id, :location_id, :previous_location_ids

  has_better_enum_for :region
  has_better_enum_for :home_region, class_name: "Region"
  has_better_enum_for :last_location, class_name: "Location", foreign_key: "location_id"
  has_better_enums_for :previous_locations, class_name: "Location"

  def initialize
    @region_id = 1
    @home_region_id = 2
    @location_id = 4
    @previous_location_ids = [1, 2, 5]
  end

end