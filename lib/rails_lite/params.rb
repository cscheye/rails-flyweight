require 'uri'
require 'debugger'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    debugger
    @params = parse_www_encoded_form(req.query_string)
    @params = @params.merge(parse_www_encoded_form(req.body))
    debugger
    a = 1
  end

  def [](key)
    @params[key]
  end

  def permit(*keys)
  end

  def require(key)
  end

  def permitted?(key)
  end

  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)
    return {} if www_encoded_form.nil?
    params_arr = URI::decode_www_form(www_encoded_form)

    params = {}

    params_arr.each do |kv_pair|
      key, val = kv_pair
      keys = parse_key(key)
      current_hash = make_hash(keys, val)
      params = params.deep_merge(current_hash)
    end
    params
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.gsub(']', '').split('[').reverse
  end

  def make_hash(keys, val)
    current_key = keys.pop
    if keys.empty?
      { current_key => val }
    else
      { current_key => make_hash(keys, val) }
    end
  end
end

