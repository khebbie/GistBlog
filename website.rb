require 'rubygems'  
require 'sinatra'  
require 'haml'
require 'open-uri'
require 'json'

class GistsAPI
  def gists_for_user(username)
    uri = "https://api.github.com/users/" + username +"/gists"
    content = open(uri).read
    parsed = JSON.parse(content)

    gists = Array.new

    parsed.each do |gistJson|
      id = gistJson["id"]
      gist = parse_gist(gistJson)
        gist.id = id
        next if File.extname(gist.filename) != ".md"
        gists << gist
      end
    gists
  end

  def gist(id)
    uri = "https://api.github.com/gists/" + id
    content = open(uri).read
    parsed = JSON.parse(content)
    
    parse_gist(parsed)
  end
  def parse_gist(json)
     filename = ""
     content = ""
     title = ""
    json["files"].each do |gistfile|
      content = gistfile[1]["content"].to_s
      filename =  gistfile[1]["filename"].to_s
      title = File.basename( filename, ".*" )
    end
    gist = Gist.new
    gist.filename = filename
    gist.content = content
    gist.title = title
    gist

  end
end

Gist = Struct.new(:content, :filename, :id, :title)

get '/gist/:id' do  
  id = params[:id]
  gistsAPI = GistsAPI.new()
  gist = gistsAPI.gist(id)
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
