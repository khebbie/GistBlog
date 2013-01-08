$:.unshift File.expand_path("../", __FILE__)
require 'rubygems'
require 'sinatra'
require './website'
run Sinatra::Application

