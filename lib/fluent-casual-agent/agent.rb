require 'fluent-logger'

module FluentCasualAgent
  module Agent
    extend self

    attr_accessor :host, :port

    def run
      self.host = FluentCasualAgent.config.host
      self.port = FluentCasualAgent.config.port

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
  end
end
