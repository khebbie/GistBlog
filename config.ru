$:.unshift File.expand_path("../", __FILE__)
require 'rubygems'
require 'sinatra'
require './website'
require File.join( File.dirname(__FILE__), 'lib', '.')
run Sinatra::Application

