module FluentCasualAgent
  module Configuration
    def config(*args)
      to_configatron(*args)
    end

    def configure
      yield config
      self
    end

    def register_default(&block)
      default = lambda do
        configure &block
      end
      default.call
      self
    end
  end

  extend Configuration
end
