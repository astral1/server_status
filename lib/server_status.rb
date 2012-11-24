require 'sinatra/base'
require 'slim'
require 'json'
require 'server_status/config'
require 'server_status/client'

Slim::Engine.set_default_options pretty: true

LIB_ROOT = File.expand_path File.dirname(__FILE__)
GEM_ROOT = File.expand_path '..', LIB_ROOT
STATIC_ROOT = File.expand_path 'public', GEM_ROOT
VIEW_ROOT = File.expand_path 'views', GEM_ROOT

require 'server_status/app'

def set_config file_name
  ServerStatusConfig.source File.expand_path file_name
  ServerStatusApp.set :port, ServerStatusConfig.port
end
