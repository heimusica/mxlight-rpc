require 'sinatra/base'
require 'digest/md5'
require 'redis'
require 'yaml'
require 'erb'

$redis = Redis.new()

module MXLight
  class RPC < Sinatra::Base

    get '/' do
      ''
    end

    get '/settings'  do
    end

    post '/settings' do
    end

    get '/settings_checksum' do
    end

    get '/is_receiving_rtmp' do
      is_receiving_rtmp?.to_s
    end

    def is_receiving_rtmp?
      # netstat seems to be the fastest/simplest way to know if the server is receiving rtmp
      # nginx provides some stat page but i didnt have good experiences with it
      # you may replace this with custom code, etc.
      netstat_output = `netstat -an |grep "my-rtmp-server:1935"`
    end

  end
  class Daemon
    attr_accessor :params
    def initialize( params )
      @params = params
      @params.store( :check_freq, 2 ) if !@params.include?(:check_freq)
      @params.store( :wait_time_after_update, 10 ) if !@params.include?(:wait_time_after_update)
    end
    def start()
      mxlight_exec = "#{@params[:mxlight_root]}\\MXLight.exe"
      puts "=> Starting MXLight"
      # puts "start #{mxlight_exec} stream-profile=\"#{@params[:default_stream_profile]}\" stream=#{@params[:stream]} gui-stats=#{@params[:gui_stats]} gui-config=#{@params[:gui_config]}"
      puts "=> Running check every #{@params[:check_freq]} secs."
      loop do
        if !remote_server_receiving_rtmp?
          self.stop()
        end
        if settings_updated?
          sync_settings()
          sleep @params[:wait_time_after_update].to_i
        end
        sleep @params[:check_freq].to_i
      end
    end
    def sync_settings
      puts "=> Fetching settings"
    end
    def stop
      puts "=> Stopping MXLight"
      # system('wmic Path win32_process Where "CommandLine Like \'%MXLight.exe%\'" Call Terminate')
      # system('wmic Path win32_process Where "CommandLine Like \'%ffmpeg.exe%\'" Call Terminate')
    end
    def remote_server_receiving_rtmp?
      true
    end
    def settings_updated?
      true
    end
  end

  def self.render_config_file(settings)
    template_file_path, settings = File.join(File.dirname(__FILE__), 'streams_template.cda'), settings
    erb_output = ERB.new(File.read(template_file_path))
    return erb_output.result(binding)
  end
end

# MXLight::render_config_file( YAML.load_file('streams_template.yml'))
