require 'rest-client'
require 'socket'
require 'timeout'

class ServerStatusClient
  def initialize(hash)
    @domain = hash[:domain.to_s]
    @port = hash[:port.to_s]
    @scheme = hash[:ssl.to_s] ? 'https' : 'http'
    @url = "#@scheme://#@domain:#@port"
    @default = hash[:apis.to_s][:default.to_s]
  end

  def request
    Timeout::timeout(5) do
      begin
        response = RestClient.get "#@url#@default"
        response.code
      rescue => e
        e.response.code
      end
    end
  rescue Timeout::Error
    return 408
  end

  #noinspection RubyResolve
  def is_port_open?
    Timeout::timeout(1) do
      begin
        s = TCPSocket.new(@domain, @port)
        s.close
        return true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        return false
      end
    end
  rescue Timeout::Error
    return false
  end
end
