# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

require 'bubble-wrap/reactor'
require 'bubble-wrap/rss_parser'

Motion::Project::App.setup do |app|
  app.name = 'Daily Republic'
  app.info_plist['LSUIElement'] = true
  app.deployment_target = '10.8'

  app.info_plist['NSAppTransportSecurity'] = {
      'NSAllowsArbitraryLoads' => true
  }

end
