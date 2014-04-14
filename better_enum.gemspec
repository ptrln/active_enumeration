Gem::Specification.new do |s|
  s.name        = 'better_enum'
  s.version     = '0.0.2'
  s.date        = '2014-04-13'
  s.summary     = "BetterEnum"
  s.description = "A better way to create complex Ruby enumeration classes"
  s.authors     = ["Peter Lin"]
  s.email       = 'peter@peterl.in'
  s.files       = ["lib/better_enum.rb", "lib/better_enum/base.rb"]
  s.homepage    = 'https://github.com/ptrln/better_enum'
  s.license     = 'MIT'

  s.add_runtime_dependency 'activesupport', '>= 2.2.1'
end