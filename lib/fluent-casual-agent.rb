# -*- encoding: utf-8 -*-

require "configatron"
require "eventmachine"

class Module
  def to_configatron(*args)
    self.name.to_configatron(*args)
  end
end

module FluentCasualAgent
  extend self

  class Error < StandardError; end

  def run(options = {})
    Thread.abort_on_exception = true

    require "#{options[:config_file]}"
    if config.targets.nil? || config.targets.size <= 0
      raise Error, "target filepath for tail is blank in configuration file."
    end

    EM.run do
      config.targets.each { |t| EM.defer { Tail.run t } }
      EM.defer { Agent.run }
      EM.defer { Network.run }
      EM.defer { Notification.run }
    end
  end

  def log_channel
    @log_channel ||= EM::Channel.new
  end

  def notify_channel
    @notify_channel ||= EM::Channel.new
  end

  require "fluent-casual-agent/version"
  require "fluent-casual-agent/configurations"
  require "fluent-casual-agent/tail"
  require "fluent-casual-agent/agent"
  require "fluent-casual-agent/network"
  require "fluent-casual-agent/notification"
end
