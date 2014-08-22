ActiveEnumeration
=====================

A simpler way to create more complex Ruby enumerations, with ActiveRecord like syntax and associations.

Author: Peter Lin - peter at ptrln.net

[![Build Status](https://secure.travis-ci.org/ptrln/active_enumeration.png)](http://travis-ci.org/ptrln/active_enumeration)


## Description

There seems to be a lot of Ruby enumeration gems out there, but none of them solved what we needed, so I created this one to behave more similar to ActiveRecord models. You are able to define associations between enumerations, and any number of attributes, allowing much greater flexibility than existing solutions.

### For example:

If you have to model Regions and their Locations, you could store this in your DB. However, these are essentially constants, and once created will never change. It seems silly to constantly hit the DB just to retrieve these.

ActiveEnumeration allows you to create these more complex enumerations easily, while maintaining associations, and various attributes that make these enumerations much more useful.

## Creating enumerations

Enumerations are created as Plain Old Ruby Objects, so you can put them whereever you like.

``` ruby
class Region < ActiveEnumeration::Base
  has_many :locations

  attr_reader :id, :name, :area_name, :time_zone

  values ({
    :bay_area    => [ 1, 'Bay Area', "San Francisco Bay Area", "Pacific Time (US & Canada)"],
    :los_angeles => [ 2, 'Los Angeles', "Los Angeles Area", "Pacific Time (US & Canada)"],
    :new_york    => [ 3, 'New York', "New York City and Tri-State Area", "Eastern Time (US & Canada)"],
    :chicago     => [ 4, 'Chicago', "Chicago Area", "Central Time (US & Canada)"],
  })

  groups({
    :live => [1, 2],
  })

  def to_s
    self.name
  end

end
```

``` ruby

class Location < ActiveEnumeration::Base
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

```

This will create some nice stuff:

*   Each enumeration's value will turn into a constant:

    ``` ruby
    Region::BAY_AREA
    #=> 1
    ```

*   You can retrieve an enumeration:

    ``` ruby
    Region.bay_area
    #=> #<Region:0x007f9258b7dd50 @active_enumeration_id=1, @id=1, @name="Bay Area", @area_name="San Francisco Bay Area", @time_zone="Pacific Time (US & Canada)"> 
    ```

*   Or you can find based on the 'id':

    ``` ruby
    Region.find(1)
    #=> #<Region:0x007f9258b7dd50 @active_enumeration_id=1, @id=1, @name="Bay Area", @area_name="San Francisco Bay Area", @time_zone="Pacific Time (US & Canada)"> 
    ```

*   You can retrieve the attributes very easily:

    ``` ruby
    Region.bay_area.time_zone
    #=> "Pacific Time (US & Canada)"
    ```

*   You can retrieve has_many associated enumerations:
    ``` ruby
    Region.bay_area.locations
    #=> [#<Location:0x007f9258b9d448 @active_enumeration_id=4, @id=4, @name="San Francisco", @region_id=1>, #<Location:0x007f9258b9d240 @active_enumeration_id=5, @id=5, @name="East Bay", @region_id=1>, #<Location:0x007f9258b9cf98 @active_enumeration_id=6, @id=6, @name="South Bay", @region_id=1>] 
    ```

*   You can retrieve belongs_to associated enumerations:

    ``` ruby
    Location.find(1).region
    #=> #<Region:0x007f9258b86a18 @active_enumeration_id=3, @id=3, @name="New York", @area_name="New York City and Tri-State Area", @time_zone="Eastern Time (US & Canada)"> 
    ```
    
*   You can retrieve all enumerations:

    ``` ruby
    Region.all
    #=> [#<Region:0x007f9258b7dd50 @active_enumeration_id=1, @id=1, @name="Bay Area", @area_name="San Francisco Bay Area", @time_zone="Pacific Time (US & Canada)">, #<Region:0x007f9258b86db0 @active_enumeration_id=2, @id=2, @name="Los Angeles", @area_name="Los Angeles Area", @time_zone="Pacific Time (US & Canada)">, #<Region:0x007f9258b86a18 @active_enumeration_id=3, @id=3, @name="New York", @area_name="New York City and Tri-State Area", @time_zone="Eastern Time (US & Canada)">, #<Region:0x007f9258b86680 @active_enumeration_id=4, @id=4, @name="Chicago", @area_name="Chicago Area", @time_zone="Central Time (US & Canada)">]
    ```

*   You can get an array of options, ready to use with the Rails 'select' helpers.

    ``` ruby
    Region.to_a
    #=> [["Bay Area", 1], ["Los Angeles", 2], ["New York", 3], ["Chicago", 4]]
    ```

*   You can create groups for your enumerations.

    ``` ruby
    Region.live
    #=> [#<Region:0x007f9258b7dd50 @active_enumeration_id=1, @id=1, @name="Bay Area", @area_name="San Francisco Bay Area", @time_zone="Pacific Time (US & Canada)">, #<Region:0x007f9258b86db0 @active_enumeration_id=2, @id=2, @name="Los Angeles", @area_name="Los Angeles Area", @time_zone="Pacific Time (US & Canada)">]
    ```

*   You can filter your enumerations using 'where'.

    ``` ruby
    Location.where(region_id: 3, name: 'Manhattan')
    #=> [#<Location:0x007f9258b9d448 @active_enumeration_id=1, @id=1, @name="Manhattan", @region_id=3>,
    ```

*   You can ask for the enumeration's count:

    ``` ruby
    Region.count
    #=> 4
    ```


## Using enumerations

You can use these enumerations with any class, however ActiveEnumeration expects an 'id' for each enumeration.

``` ruby
class Person
  extend ActiveEnumeration

  attr_accessor :region_id, :home_region_id, :location_id, :previous_location_ids

  has_active_enumeration_for  :region
  has_active_enumeration_for  :home_region, class_name: "Region"
  has_active_enumeration_for  :last_location, class_name: "Location", foreign_key: "location_id"
  has_active_enumerations_for :previous_locations, class_name: "Location"
  
  ...

end
```

*   You easily retrieve a Person's region:

    ``` ruby
    person.region
    #=> #<Region:0x007f9258b7dd50 @active_enumeration_id=1, @id=1, @name="Bay Area", @area_name="San Francisco Bay Area", @time_zone="Pacific Time (US & Canada)">
    ```
    
*   And through that, retrieve useful attributes.

    ``` ruby
    person.region.time_zone
    #=> "Pacific Time (US & Canada)"
    ```

*   Also helper methods that make checking these enumerations easier

    ``` ruby
    person.region.bay_area?
    #=> true
    
    person.region.chicago?
    #=> false
    ```

## Using with Rails

*   Add the gem to your Gemfile:

    ``` ruby
    gem "active_enumeration"
    ```

## Why did you make this gem?

There are other similar solutions to the problem out there, but I did not find any that included associations between enumerations. I also found learning a new syntax kind of annoying, so I thought it'll be nice to have everything work with ActiveRecord like syntax.

Benefits:

*   Take constants out of your DB, eliminate unnecessary DB reads.
*   You can add many more attributes to your enumeration class.
*   You can group your enumerations.
*   You can have associations between your enumerations.
*   No need to learn a new DSL, since most of the functionality behaves similarly to ActiveRecord.