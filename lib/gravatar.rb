require 'digest/md5'

class Gravatar
  def get_image_url(email_address)
    email_address = email_address.downcase
    hash = Digest::MD5.hexdigest(email_address)
    image_src = "http://www.gravatar.com/avatar/#{hash}"
  end
end
