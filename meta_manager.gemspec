$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "meta_manager/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "meta_manager"
  s.version     = MetaManager::VERSION
  s.authors     = ["Pavel Galeta"]
  s.email       = ["superp1987@gmail.com"]
  s.homepage    = "https://github.com/superp/meta_manager"
  s.summary     = "Head meta tags manager for models."
  s.description = "Aimbulance CMS"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.1.3"

  s.add_development_dependency "sqlite3"
end
