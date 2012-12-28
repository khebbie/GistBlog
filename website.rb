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

    filename = ""
    gists = Array.new

    parsed.each do |gistJson|
      id = gistJson["id"]
      gistJson["files"].each do |gistfile|
        content = gistfile[1]["content"].to_s
        filename =  gistfile[1]["filename"].to_s
        next if File.extname(filename) != ".md"

        filename = File.basename( filename, ".*" )
        gist = Gist.new
        gist.filename = filename
        gist.content = content
        gist.id = id

        gists << gist
      end
    end
    gists
  end

  def gist(id)
    uri = "https://api.github.com/gists/" + id
    content = open(uri).read
    parsed = JSON.parse(content)
    filename = ""

    parsed["files"].each do |gistfile|
      content = gistfile[1]["content"].to_s
      filename =  gistfile[1]["filename"].to_s
      filename = File.basename( filename, ".*" )
    end
    gist = Gist.new
    gist.filename = filename
    gist.content = content
    gist
  end
end

class Gist
  attr_accessor :content
  attr_accessor :filename
  attr_accessor :id

end

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
