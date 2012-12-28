path = File.expand_path("../", __FILE__)

require 'rubygems'
require 'sinatra'
require "#{path}/website"

run Sinatra::Application
