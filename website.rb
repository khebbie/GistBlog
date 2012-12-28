require 'rubygems'  
require 'sinatra'  
require 'haml'
require 'open-uri'
require 'json'

get '/gist/:id' do  
  id = params[:id]
  uri = "https://api.github.com/gists/" + id
  content = open(uri).read
  parsed = JSON.parse(content)

  parsed["files"].each do |gistfile|
    content = gistfile[1]["content"].to_s
  end
  
  haml :index  , :locals => {:content => content}
end 
