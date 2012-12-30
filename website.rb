require 'rubygems'  
require 'sinatra'  
require 'haml'
require 'open-uri'
require 'json'

Gist = Struct.new(:content, :filename, :title, :id) do
  def empty?()
    false
  end
end

class GistsAPI
  def gists_for_user(username)
    uri = "https://api.github.com/users/" + username +"/gists"
    content = open(uri).read
    parsed = JSON.parse(content)

    gists = Array.new

   parsed.each do |gistJson|
      id = gistJson["id"]
      gist = parse_gist(gistJson, id)
      p gist
      next if gist.empty?
      filename = gist.filename
      next if File.extname(filename) != ".md"

      gists << gist
    end
    gists
  end

  def gist_by(id)
    uri = "https://api.github.com/gists/" + id
    content = open(uri).read
    parsed = JSON.parse(content)
    
    parse_gist(parsed)
  end
  def parse_gist(json, id = "0")
    json["files"].each do |gistfile|

      content = gistfile[1]["content"].to_s
      filename =  gistfile[1]["filename"].to_s
      title = File.basename( filename, ".*" )
      
      return Gist.new(content, filename, title, id)
    end
  end
end

get '/gist/:id' do  
  id = params[:id]
  gistsAPI = GistsAPI.new()
  gist = gistsAPI.gist_by(id)
  haml :index  , :locals => {:content => gist.content, :filename => gist.filename}
end

get '/' do
  gistsAPI = GistsAPI.new()
  @gists = gistsAPI.gists_for_user("khebbie")
  haml :home
end

get '/about' do
  haml :about
end
