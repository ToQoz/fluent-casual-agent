module FluentCasualAgent
  module Observer
    extend self

    def run
      while true
        unless FluentCasualAgent.ping
          FluentCasualAgent.notify "[#{host}:#{port} is dead.]"
        end
        sleep config.interval
      end
    end

    def host
      FluentCasualAgent.config.host
    end

    def port
      FluentCasualAgent.config.port
    end

    def config
      FluentCasualAgent.config.observer
    end

  end

  register_default do |config|
    config.observer.set_default(:interval, 180)
  end
end
