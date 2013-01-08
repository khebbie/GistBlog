require 'rubygems'  
require 'sinatra'  
require "sinatra/config_file"
require 'haml'
require 'json'
configure do
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| 
    require File.basename(lib, '.*') 
  }
end


config_file 'config.yml'

def getGistApi()
   decorated = GistsAPI.new()
   GistCache.new(settings.redisUrl, decorated)
end

get '/gist/:id' do  
  id = params[:id]
  gistsAPI = getGistApi()
  gist = gistsAPI.gist_by(id)
  haml :index , :locals => {:content => gist.content, :title => gist.title} 
end

get '/' do
  gistsAPI = getGistApi()
  @gists = gistsAPI.gists_for_user(settings.githubUsername)
  haml :home
end

get '/about' do
  @image_src = Gravatar.new().get_image_url(settings.gravatarEmail)
  haml :about
end
