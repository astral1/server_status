require 'rest-client'

class ServerStatusClient
  def initialize hash
    @domain = hash[:domain.to_s]
    @port = hash[:port.to_s]
    @scheme = hash[:ssl.to_s] ? 'https' : 'http'
    @url = "#{@scheme}://#{@domain}:#{@port}"
    @default = hash[:apis.to_s][:default.to_s]
  end

  def request
    response = RestClient.get "#{@url}#{@default}"
    response.code
  rescue => e
    e.response.code
  end
end
