require 'rubygems'  
require 'sinatra'  
require "sinatra/config_file"
require 'haml'
require 'json'
require './lib/gistApi.rb'
require './lib/gravatar.rb'

config_file 'config.yml'

get '/gist/:id' do  
  id = params[:id]
  gistsAPI = GistsAPI.new()
  gist = gistsAPI.gist_by(id)
  haml :index , :locals => {:content => gist.content, :title => gist.title} 
end

get '/' do
  gistsAPI = GistsAPI.new()
  @gists = gistsAPI.gists_for_user(settings.githubUsername)
  haml :home
end

get '/about' do
  @image_src = Gravatar.new().get_image_url(settings.gravatarEmail)
  haml :about
end
