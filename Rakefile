require 'rake/clean'
require 'yard'

CLEAN.include(Dir['**/*'] - `git ls-files`.split("\n"))
Rake::Task['clobber'].clear

YARD::Rake::YardocTask.new do |yard|
  yard.options = [
    '--title',  'Ruby Digest Documentation',
    '--readme', 'README.md',
    '--files',  'UNLICENSE',
    '--markup', 'markdown'
  ]
end

namespace :spec do
  desc 'Run detailed RSpec tests'
  task :nested do
    sh 'rspec spec --color --format documentation'
  end
  
  desc 'Run RSpec tests (`rake` default task)'
  task :run do
    sh 'rspec spec --color'
  end
end

task :readme do
  File.open('README.md', 'w') do |readme|
    File.read('lib/ruby_digest.rb') =~ /#-{2}(.+)#\+{2}/m
    readme << $1.gsub!(/^# /, '')
    puts "Generated README.md file (#{File.expand_path(readme)})"
  end
end

task :spec    => 'spec:nested'
task :default => 'spec:run'
