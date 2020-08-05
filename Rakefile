require 'glimmer/rake_task'

Glimmer::Package.javapackager_extra_args =
  # General Options
  " -native #{ENV['NATIVE'] || ('dmg' if OS.mac?) || ('msi' if OS.windows?)}" +
  " -name 'Math Bowling 2'" +
  " -title 'Math Bowling 2'" +
  # Linux Options 
  " -BlicenseType=MIT" +
  " -Bcopyright='Copyright (c) 2019-2020 Andy Maleh.'" +
  " -Bcategory='Game'" +
  " -Bvendor='Andy Maleh'" +
  # Mac Options
  " -Bmac.CFBundleName='Math Bowling 2'" +
  " -Bmac.CFBundleIdentifier=org.andymaleh.application.MathBowling2" +
  " -Bmac.category=public.app-category.educational-games" +
  " -Bmac.signing-key-developer-id-app='Andy Maleh'"      
  
# require 'glimmer/launcher'
require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
#   spec.ruby_opts = [Glimmer::Launcher.jruby_swt_options]
end

task :default => :spec

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "math_bowling"
  gem.homepage = "http://github.com/AndyObtiva/math_bowling"
  gem.license = "MIT"
  gem.summary = %Q{Math Game with Bowling Rules}
  gem.description = %Q{Math Game with Bowling Rules}
  gem.email = "andy.am@gmail.com"
  gem.authors = ["Andy Maleh"]
  gem.require_paths = ['vendor']
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new
