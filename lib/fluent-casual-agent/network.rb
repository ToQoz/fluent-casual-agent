require "net/ping"

module FluentCasualAgent
  module Network
    extend self

    def run
      raise Error, "#{host}:#{port} is dead." unless ping

      loop do
        FluentCasualAgent.notify_channel << "[#{host}:#{port} is dead.]" unless ping
        sleep config.observer.interval
      end
    end

    def config
      FluentCasualAgent.config.network
    end

    def host
      config.host
    end

    def port
      config.port
    end

    def ping
      Net::Ping::TCP.new(host, port).ping
    end

  end

  register_default do |config|
    config.network.set_default(:host, "0.0.0.0")
    config.network.set_default(:port, '24224')
    config.network.observer.set_default(:interval, 180)
  end
end
