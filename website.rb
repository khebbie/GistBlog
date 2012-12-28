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
  filename = ""
  
  parsed["files"].each do |gistfile|
    content = gistfile[1]["content"].to_s
    filename =  gistfile[1]["filename"].to_s
    filename = File.basename( filename, ".*" )
  end
  
  haml :index  , :locals => {:content => content, :filename => filename}
end

get '/' do
  uri = "https://api.github.com/users/khebbie/gists"

   content = open(uri).read
  parsed = JSON.parse(content)
   haml :home


end

get '/about' do
  haml :about
end
