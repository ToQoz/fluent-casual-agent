# -*- encoding: utf-8 -*-

require "configatron"
require "eventmachine"
require "net/ping"

class Module
  def to_configatron(*args)
    self.name.to_configatron(*args)
  end
end

module FluentCasualAgent
  extend self

  class Error < StandardError; end

  def run(options = {})
    require "#{options[:config_file]}"
    register_default do |config|
      config.set_default(:host, "0.0.0.0")
      config.set_default(:port, '24224')
    end

    Thread.abort_on_exception = true

    raise Error, "#{config.host}:#{config.port} is dead." unless ping

    unless !config.targets.nil? && config.targets.size > 0
      raise Error, "target filepath for tail is blank in configuration file." 
    end

    EM.run do
      config.targets.each { |t| EM.defer { Tail.run t } }
      EM.defer { Agent.run }
      EM.defer { Observer.run }
    end
  end

  def ping
    Net::Ping::TCP.new(config.host, config.port).ping
  end

  def notify(msg)
    puts msg
    Notification.push msg
  end

  def channel
    @channel ||= EM::Channel.new
  end

  require "fluent-casual-agent/version"
  require "fluent-casual-agent/configurations"
  require "fluent-casual-agent/tail"
  require "fluent-casual-agent/agent"
  require "fluent-casual-agent/observer"
  require "fluent-casual-agent/notification"
end
