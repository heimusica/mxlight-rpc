require 'sinatra/base'
require 'yaml'

module MXLight
  class RPC < Sinatra::Base
    get '/' do
      ''
    end

    get '/settings'  do
    end

    post '/settings' do
    end

  end
  class Daemon
    def initialize()
    end
  end
end
