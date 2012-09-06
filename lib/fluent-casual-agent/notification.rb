require 'carrier-pigeon'

module FluentCasualAgent
  module Notification
    extend self

    def push(msg)
      IRC.push msg
    end

    module IRC
      extend self

      def push(msg)
        CarrierPigeon.send(opts msg) unless config.nil?
      end

      def opts(msg)
        { uri: uri, message: "#{msg} #{config.message}", join: true }
      end

      def uri
        "irc://#{config.nick}:#{config.password}@#{config.host}:#{config.port}/#{config.channel}"
      end

      def config
        FluentCasualAgent.config.notifications.irc
      end

    end

  end

  register_default do |config|
    unless config.irc.nil?
      config.irc.set_default(:password, "")
      config.irc.set_default(:port, "6667")
      config.irc.set_default(:message, "fluentd is dead")
    end
  end
end
