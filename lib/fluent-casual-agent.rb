# -*- encoding: utf-8 -*-

require "configatron"
require "eventmachine"

require "fluent-casual-agent/version"
require "fluent-casual-agent/tail"
require "fluent-casual-agent/agent"

class Module
  def to_configatron(*args)
    self.name.to_configatron(*args)
  end
end

module FluentCasualAgent
  extend self

  def run(options = {})
    Thread.abort_on_exception = true
    EM.run do
      FluentCasualAgent.config.targets.each { |t|
        EM.defer { Tail.run(t) }
      }
      EM.defer { Agent.run() }
    end
  end

  def channel
    @channel ||= EM::Channel.new
  end

  module Configuration
    def config(*args)
      to_configatron(*args)
    end

    def configure
      yield config
      self
    end
  end

  extend Configuration
end
