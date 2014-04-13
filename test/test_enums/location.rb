class Location < ActiveEnum::Base
  belongs_to :region
  
  attr_reader :id, :name, :region_id
  
  values ({
   # NY
    :manhattan                   => [ 1, 'Manhattan', 3],
    :brooklyn                    => [ 2, 'Brooklyn', 3],
    :bronx                       => [ 3, 'Bronx', 3],
   # SF
    :san_francisco               => [ 4, 'San Francisco', 1],
    :east_bay                    => [ 5, 'East Bay', 1],
    :south_bay                   => [ 6, 'South Bay', 1],
   # LA
    :los_angeles_county          => [ 7, 'Los Angeles County', 2],
    :orange_county               => [ 8, 'Orange County', 2],
   # Chicago
    :greater_chicago_area        => [ 9, "Greater Chicago Area", 4] 
  })

end