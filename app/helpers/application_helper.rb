module ApplicationHelper
  require "digest/md5"

  def avatar_url(user)
    default_url = "#{root_url}images/iruby.png"
    gravatar_id = Digest::MD5.hexdigest(user.email).downcase
    Rails.env.production? ? "https://s.gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}?": default_url
  end
end
