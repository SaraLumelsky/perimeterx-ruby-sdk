require "perimeterx/utils/px_logger"
require "httpclient"

class PxHttpClient
  L = PxLogger.instance
  attr_accessor :px_config
  attr_accessor :BASE_URL
  attr_accessor :http_client

  def initialize(px_config)
    L.debug("PxHttpClient[initialize]: HTTP client is being initilized with base_uri: #{px_config['perimeterx_server_host']}")
    @px_config = px_config
    @http_client = HTTPClient.new(:base_url => px_config['perimeterx_server_host'])
  end

  def post(path, body, headers, connection_timeout = 0, timeoute = 0)
    s = Time.now
    begin
      L.debug("PxHttpClient[post]: posting to #{path} headers {#{headers.to_json()}} body: {#{body.to_json()}} ")
      response = @http_client.post(path,
                  :header => headers,
                  :body => body.to_json(),
                  :timeout => @px_config['api_timeout']
                )
    rescue Net::OpenTimeout, Net::ReadTimeout => error
      L.warn("PerimeterxS2SValidator[verify]: request timedout")
      return false
    end
    e = Time.now
    L.debug("PxHttpClient[post]: runtime: #{e-s}")
    return response
  end

  def async_post(path, body, headers, connection_timeout = 0, timeoute = 0)
    L.debug("PxHttpClient[async_post]: posting to #{path} headers {#{headers.to_json()}} body: {#{body.to_json()}} ")
  end

end
