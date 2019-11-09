lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "integral/slug_generator/version"

Gem::Specification.new do |spec|
  spec.name        = "integral-slug_generator"
  spec.version     = Integral::SlugGenerator::VERSION
  spec.authors     = ["Sergey Pedan"]
  spec.email       = ["sergey.pedan@gmail.com"]
  spec.summary     = %q{Generates a DB-unique & validated slug}
  spec.description = %q{Checks existence of a record with a slug and re-generates until succeess}
  spec.homepage    = "https://github.com/sergeypedan/integral-slug-generator"

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = [spec.homepage, "Changelog.md"].join('/')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency "cyrillizer"
end
