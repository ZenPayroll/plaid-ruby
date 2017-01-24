Gem::Specification.new do |s|
  s.name        = 'plaid'
  s.version     = '0.1.7.0.zp'
  s.date        = '2014-04-11'
  s.summary     = 'Plaid Ruby Gem'
  s.description = 'Ruby Gem wrapper for Plaid API.'
  s.authors     = ['Justin Crites', 'Gamble McAdam', 'Rahul Ramakrishnan']
  s.email       = 'justin@guavatext.com'
  s.files       = Dir.glob('lib/**/*')
  s.homepage    = 'https://github.com/plaid/plaid-ruby'
  s.license     = 'MIT'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-mocks'
end
