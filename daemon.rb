#!/usr/bin/env ruby

require './mxlight-rpc'

mxlightd = MXLight::Daemon.new( :mxlight_root => 'C:\MXLight-2.1.8-demo\\',
                                :default_stream_profile => :RTMP,
                                :gui_stats => :hide,
                                :gui_config => :hide )

mxlightd.start()
