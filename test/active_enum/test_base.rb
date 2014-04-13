require 'test/unit'
require 'active-enum'

class BaseTest < Test::Unit::TestCase

  class << self
    def startup
      Location
      Region
    end
  end

  def test_initialize
    p 'initialize'
  end

  # no tests yet...
  # TODO: write some tests
end