require 'rubygems'
require 'redis'

class GistCache
   def initialize(redisUrl, gistApi)
     @redisUrl = redisUrl
     @gistApi = gistApi
   end

  def get_redis()
    uri = URI.parse(@redisUrl)
    Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end

  def get_cached_value(key, lookupNoCache)
     redis = get_redis()
     if redis[key]
       serialized_object = redis[key]
       content = Marshal.load(serialized_object)
       p content
     else
       content = lookupNoCache.call(key)
        if !content.empty?
         redis[key] = serialized_object = Marshal.dump(content)
         redis.expire(key, 60*60)
        end
      end
      content
  end

  def gists_for_user(username)
    get_cached_value(username, lambda {|key| @gistApi.gists_for_user(key)} )
  end

 def gist_by(id)
   get_cached_value(id, lambda {|key| @gistApi.gist_by(key)} )
 end
end
