# frozen_string_literal: true

require_relative 'lib/quake_log/version'

Gem::Specification.new do |spec|
  spec.name        = 'quake_log'
  spec.version     = QuakeLog::VERSION
  spec.authors     = ['denysnando']
  spec.email       = ['denysnando@gmail.com']
  spec.homepage    = 'https://github.com/denysnando/quake_log'
  spec.summary     = 'Summary of QuakeLog.'
  spec.description = 'Description of QuakeLog.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_development_dependency 'pry', '>= 0.14.2'
  spec.add_dependency 'rails', '>= 7.0.5'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.56.2'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
