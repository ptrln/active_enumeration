class Location < ActiveEnum::Base
  belongs_to :region
  
  attr_reader :id, :name, :region_id, :something
  
  values ({
   # NY
    :manhattan                   => [ 8, 'Manhattan', 3, false],
    :brooklyn_queens             => [22, 'Brooklyn/Queens', 3, false],
    :bronx                       => [ 1, 'Bronx', 3, false],
    :staten_island               => [15, 'Staten Island', 3, false],
    :westchester                 => [18, 'Westchester/Hudson Valley', 3, false],
    :long_island                 => [ 6, 'Long Island/Hamptons', 3, false],
    :new_jersey                  => [10, 'Northern New Jersey', 3, false],
    :west_connecticut            => [19, 'Western Connecticut', 3, false],
    :further_travel_ny           => [ 4, 'Further Travel Around NY', 3, true],
   # SF
    :san_francisco               => [13, 'San Francisco', 1, false],
    :east_bay                    => [ 2, 'East Bay', 1, false],
    :peninsula                   => [12, 'Peninsula', 1, false],
    :wine_country                => [20, 'Wine Country', 1, false],
    :south_bay                   => [14, 'South Bay', 1, false],
    # :santa_cruz                   => [106, 'Santa Cruz', 1],
    # :monterey                     => [107, 'Monterey', 1],
    # :sacremento                   => [108, 'Sacremento', 1],
    :marin                       => [ 9, 'Marin', 1, false],
    :tahoe                       => [16, 'Tahoe', 1, false],
    :further_travel_sf           => [ 5, 'Further Travel Around SF', 1, true],
   # LA
    :los_angeles_county          => [ 7, 'Los Angeles County', 2, false],
    :orange_county               => [11, 'Orange County', 2, false],
    :ventura_county              => [17, 'Ventura County', 2, false],
    :further_travel_la           => [ 3, 'Further Travel Around LA', 2, true],
   # Chicago
    :greater_chicago_area        => [21, "Greater Chicago Area", 5, true] 
  })

end