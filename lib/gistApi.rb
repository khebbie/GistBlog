require 'rubygems'  
require 'open-uri'
require 'redis'

Gist = Struct.new(:content, :filename, :title, :id) do
  def empty?()
    false
  end
end

class GistsAPI
  def initialize(redisUrl)
    @redisUrl = redisUrl
  end

  def get_redis()
    p @redisUrl
    uri = URI.parse(@redisUrl)
    Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end
  def get_url(uri)
    redis = get_redis()
    if redis[uri]
      content = redis[uri]
    else
      io =  open(uri)
      content = io.read
     if io.status == ["200", "OK"]
       redis[uri] = content
       redis.expire(uri, 60*60)
      end
    end
    content
  end
  def gists_for_user(username)
    uri = "https://api.github.com/users/" + username +"/gists"
    content = get_url(uri) 

    parsed = JSON.parse(content)

    gists = Array.new

   parsed.each do |gistJson|
      id = gistJson["id"]
      gist = parse_gist(gistJson, id)
      next if gist.empty?
      filename = gist.filename
      next if File.extname(filename) != ".md"

      gists << gist
    end
    gists
  end

  def gist_by(id)
    uri = "https://api.github.com/gists/" + id
    content = get_url(uri) 
    json = JSON.parse(content)
    
    parse_gist(json)
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
