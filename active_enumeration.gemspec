Gem::Specification.new do |s|
  s.name        = 'active_enumeration'
  s.version     = '0.0.4'
  s.date        = '2014-04-13'
  s.summary     = "ActiveEnumeration"
  s.description = "A simpler way to create more complex Ruby enumerations, with ActiveRecord like syntax and associations."
  s.authors     = ["Peter Lin"]
  s.email       = 'peter@peterl.in'
  s.files       = ["lib/active_enumeration.rb", "lib/active_enumeration/base.rb"]
  s.homepage    = 'https://github.com/ptrln/active_enumeration'
  s.license     = 'MIT'

  s.add_runtime_dependency 'activesupport', '>= 2.2.1'
end