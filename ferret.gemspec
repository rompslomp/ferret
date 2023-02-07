require 'rake'
require File.expand_path("../ruby/lib/ferret/version", __FILE__)

EXT_SRC = FileList["c/src/*.[ch]", "c/include/*.h",
                   "c/lib/bzlib/*.[ch]",
                   "c/lib/libstemmer_c/src_c/*.[ch]",
                   "c/lib/libstemmer_c/runtime/*.[ch]",
                   "c/lib/libstemmer_c/libstemmer/*.[ch]",
                   "c/lib/libstemmer_c/include/libstemmer.[h]"]
EXT_SRC.exclude('c/**/ind.[ch]',
                'c/**/symbol.[ch]',
                'c/include/threading.h',
                'c/include/scanner.h',
                'c/include/internal.h',
                'c/src/lang.c',
                'c/include/lang.h')

EXT_SRC_MAP = {}
EXT_SRC_DEST = EXT_SRC.map do |fn|
  ext_fn = File.join("ruby/ext", File.basename(fn))
  if fn =~ /.c$/ and fn =~ /(bzlib|stemmer)/
    prefix = $1.upcase
    ext_fn.gsub!(/ruby\/ext\//, "ruby/ext/#{prefix}_")
  end
  EXT_SRC_MAP[fn] = ext_fn
end
SRC = FileList["ruby/ext/*.[ch]", EXT_SRC_DEST, 'ruby/ext/internal.h'].uniq

PKG_FILES = FileList[
  'ruby/[-A-Z]*',
  'ruby/lib/**/*.rb',
  'ruby/lib/**/*.rhtml',
  'ruby/lib/**/*.css',
  'ruby/lib/**/*.js',
  'ruby/test/**/*.rb',
  'ruby/test/**/wordfile',
  'ruby/rake_utils/**/*.rb',
  'ruby/Rakefile',
  SRC
]

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
  s.files = PKG_FILES.to_a
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
