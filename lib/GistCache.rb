require 'rubygems'
require 'redis'

class GistCache
   def initialize(redisUrl, gistApi)
     @redisUrl = redisUrl
     @component = gistApi
   end

  def get_redis()
    uri = URI.parse(@redisUrl)
    Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end

  def method_missing(meth, *args)
     key = args[0]
     get_value(key)
  end

  def get_value(key)
     redis = get_redis()
     if redis[key]
       serialized_object = redis[key]
       content = Marshal.load(serialized_object)
       p content
     else
       content = @component.send(meth, *args)
        if !content.empty?
         serialized_object = Marshal.dump(content)
         redis.setex(key, 60*60, serialized_object)
        end
      end
      content
  end

  def responds_to?(meth)
    @component.respond_to?(meth)
  end

end
