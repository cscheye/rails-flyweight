require 'json'
require 'webrick'
require 'debugger'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    cookie = req.cookies.select{ |c| c.name == '_rails_lite_app'}.first

    @cookie =  cookie.nil? ? {} : JSON.parse(cookie.value.to_s)
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    cookie = WEBrick::Cookie.new('_rails_lite_app', @cookie.to_json)
    res.cookies << cookie
  end
end
