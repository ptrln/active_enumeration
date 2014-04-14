class Person
  extend BetterEnum

  has_better_enum_for :region
  has_better_enum_for :home_region, class_name: "Region"
  has_better_enum_for :last_location, class_name: "Location", foreign_key: "location_id"
  # has_better_enums_for :previous_locations, class_name: "Location"

  def region_id
    1
  end

  def home_region_id
    2
  end

  def location_id
    4
  end

  def previous_location_ids
    [1, 2, 5]
  end

end