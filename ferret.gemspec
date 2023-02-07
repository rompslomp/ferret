require File.expand_path("../ruby/lib/ferret/version", __FILE__)

windows = (RUBY_PLATFORM =~ /win32|cygwin/) rescue nil

Gem::Specification.new do |s|
  #### Basic information.
  s.name = 'ferret'
  s.version = Ferret::VERSION
  s.summary = "Ruby indexing library."
  s.description = "Ferret is a super fast, highly configurable search library."
  s.licenses = ["MIT"]

  #### Dependencies and requirements.
  s.add_development_dependency('rake', '~> 10.0')
  s.files = Dir[
    'ruby/[-A-Z]*',
    'ruby/lib/**/*.rb',
    'ruby/lib/**/*.rhtml',
    'ruby/lib/**/*.css',
    'ruby/lib/**/*.js',
    'ruby/ext/*.rb',
    'ruby/ext/*.c',
    'ruby/ext/*.h',
    'ruby/test/**/*.rb',
    'ruby/test/**/wordfile',
    'ruby/rake_utils/**/*.rb',
    'ruby/Rakefile',
  ]
  s.extensions << "ruby/ext/extconf.rb"
  s.require_path = 'ruby/lib'
  s.bindir = 'ruby/bin'
  s.executables = ['ferret-browser']

  #### Author and project details.
  s.author = "David Balmain"
  s.email = "dbalmain@gmail.com"
  #s.homepage = "http://ferret.davebalmain.com/trac"
  s.homepage = "http://github.com/jkraemer/ferret"

  if windows
    s.files = PKG_FILES.to_a + ["ruby/ext/#{EXT}"]
    s.extensions.clear
    s.platform = Gem::Platform::WIN32
  else
    s.platform = Gem::Platform::RUBY
  end
end
