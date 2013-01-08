$:.unshift File.expand_path("../", __FILE__)
require 'rubygems'
require 'sinatra'
require './website'
configure do
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| 
    require File.basename(lib, '.*') 
  }
end

run Sinatra::Application

