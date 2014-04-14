class Region < BetterEnum::Base
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
  })

  def to_s
    self.name
  end

end


class Location < BetterEnum::Base
  belongs_to :region
  
  attr_reader :id, :name, :region_id
  
  values ([
    # NY
    [ 1, 'Manhattan', 3],
    [ 2, 'Brooklyn', 3],
    [ 3, 'Bronx', 3],
    # SF
    [ 4, 'San Francisco', 1],
    [ 5, 'East Bay', 1],
    [ 6, 'South Bay', 1],
    # LA
    [ 7, 'Los Angeles County', 2],
    [ 8, 'Orange County', 2],
    # Chicago
    [ 9, "Greater Chicago Area", 4] 
  ])

end
