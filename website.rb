require 'rubygems'  
require 'sinatra'  
require 'haml'
require 'json'
require './lib/gistApi.rb'

get '/gist/:id' do  
  id = params[:id]
  gistsAPI = GistsAPI.new()
  gist = gistsAPI.gist_by(id)
  haml :index , :locals => {:content => gist.content, :title => gist.title} 
end

get '/' do
  gistsAPI = GistsAPI.new()
  @gists = gistsAPI.gists_for_user("khebbie")
  haml :home
end

get '/about' do
  haml :about
end
