# Add lib/ to the load path
$LOAD_PATH.unshift(File.expand_path(File.join('..', 'lib'), File.dirname(__FILE__)))

# Load up our Gemfile
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :test)

# Enable coverage reporting
require 'simplecov'
