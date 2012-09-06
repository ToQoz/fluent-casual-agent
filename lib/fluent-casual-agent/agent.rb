require 'fluent-logger'

module FluentCasualAgent
  module Agent
    extend self

    def run
      FluentCasualAgent.channel.subscribe do |msg|
        tag, *value_list = msg.split(",")
        value = value_list.join(",")

        puts "{ tag: \"#{tag}\", value: \"#{value}\" }"
        logger.post(tag, value)
      end
    end

    def logger
      @logger ||= Fluent::Logger::FluentLogger.new(nil, host: host, port: port)
    end

    def host
      FluentCasualAgent.config.host
    end

    def port
      FluentCasualAgent.config.port
    end

  end
end
