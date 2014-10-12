require 'sinatra/base'
require 'yaml'
require 'erb'

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
    attr_accessor :params
    def initialize( params )
      @params = params
    end
    def start()
      mxlight_exec = "#{@params[:mxlight_root]}\\MXLight.exe"
      puts "start #{mxlight_exec} stream-profile=\"#{@params[:default_stream_profile]}\" stream=#{@params[:stream]} gui-stats=#{@params[:gui_stats]} gui-config=#{@params[:gui_config]}"
    end
    def stop
      system('wmic Path win32_process Where "CommandLine Like \'%MXLight.exe%\'" Call Terminate')
      system('wmic Path win32_process Where "CommandLine Like \'%ffmpeg.exe%\'" Call Terminate')
    end
  end

  def self.render_config_file(settings)
    template_file_path, settings = File.join(File.dirname(__FILE__), 'streams_template.cda'), settings
    erb_output = ERB.new(File.read(template_file_path))
    print erb_output.result(binding)
  end
end

# MXLight::render_config_file( YAML.load_file('streams_template.yml'))
