require 'sinatra/base'
require 'slim'
require 'server_status/config'

Slim::Engine.set_default_options pretty: true

LIB_ROOT = File.expand_path File.dirname(__FILE__)
GEM_ROOT = File.expand_path '..', LIB_ROOT
STATIC_ROOT = File.expand_path 'public', GEM_ROOT
VIEW_ROOT = File.expand_path 'views', GEM_ROOT

class ServerStatus < Sinatra::Base
  set :root, GEM_ROOT
  set :server, :thin

  get '/' do
    slim :index
  end

  get '/:server/status' do
  end
end

def set_config file_name
  ServerStatusConfig.source File.expand_path file_name
  ServerStatus.set :port, ServerStatusConfig.port
end
