class ServerStatusApp < Sinatra::Base
  set :root, GEM_ROOT
  set :server, :thin

  class << self
    def check server
      server_config = ServerStatusConfig.servers[server.to_sym]
      client = ServerStatusClient.new server_config
      status_code = client.request.to_s
      Status.new server, server_config[:description.to_s], status_code, client.is_port_open?
    end
  end

  get '/' do
    @server_status = ServerStatusConfig.servers.keys.collect do |server|
      ServerStatusApp.check server
    end

    slim :index
  end

  get '/servers' do
    ServerStatusConfig.servers.keys.to_json
  end

  get '/:server/status' do
    ServerStatusApp.check(params[:server].to_sym).to_json
  end

  class Status
    attr_reader :code, :name, :description

    def initialize name, description, code, is_open
      @code, @name, @description, @is_open = code.to_i, name, description, is_open
    end

    def is_open?
      @is_open
    end

    def to_json
      {name: @name, code: @code, description: @description, is_open: @is_open}.to_json
    end
  end
end

