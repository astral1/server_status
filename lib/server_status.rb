require 'sinatra/base'
require 'slim'

LIB_ROOT = File.expand_path File.dirname(__FILE__)
GEM_ROOT = File.expand_path '..', LIB_ROOT
STATIC_ROOT = File.expand_path 'public', GEM_ROOT
VIEW_ROOT = File.expand_path 'views', GEM_ROOT

class ServerStatus < Sinatra::Base
  set :root, GEM_ROOT

  get '/' do
    slim :index
  end
end
