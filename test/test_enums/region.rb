class Region < ActiveEnum::Base
  has_many :locations

  attr_reader :id, :name, :area_name, :time_zone

  values ({
    :bay_area         => [ 1, 'Bay Area', "San Francisco Bay Area", "Pacific Time (US & Canada)"],
    :los_angeles      => [ 2, 'Los Angeles', "Los Angeles Area", "Pacific Time (US & Canada)"],
    :new_york         => [ 3, 'New York', "New York City and Tri-State Area", "Eastern Time (US & Canada)"],
    :chicago          => [ 4, 'Chicago', "Chicago Area", "Central Time (US & Canada)"],
  })

  groups({
    :live => [1, 2],
  });

  def to_s
    self.name
  end

end