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
    @payload = @default[:payload.to_s]
    @payload ||= {}
  end

  def request
    header, method, params = parse_params
    Timeout::timeout(5) do
      begin
        case method 
        when :get
          header[:params] = params
          response = RestClient.get "#@url#{@default[:url.to_s]}", header
        when :post
          response = RestClient.post "#@url#{@default[:url.to_s]}", params.to_json, header
        end
        response.code
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        return 503
      rescue => e
        e.response.code
      end
    end
  rescue Timeout::Error
    return 408
  end

  def parse_params
    header = {}
    method = :get
    params = {}
    if @payload.has_key? :header.to_s
      header = @payload[:header.to_s]
    end
    if @payload.has_key? :method.to_s
      method = @payload[:method.to_s].downcase.to_sym
    end
    if @payload.has_key? :params.to_s
      params = @payload[:params.to_s]
    end
    [header, method, params]
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

  private :parse_params
end
