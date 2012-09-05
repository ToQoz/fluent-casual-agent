module FluentCasualAgent
  module Tail
    extend self

    ENTITY_MAP = {
      "&lt;" => "<",
      "&gt;" => ">",
    }

    def run(target)
      path = target[:path]
      tag = target[:tag]
      separator = ','

      raise FluentCasualAgent::Error, "#{path} is not exists!" unless File.exist?(path)
      raise FluentCasualAgent::Error, "#{tag} contains `#{separator}`. you should remove." if tag.index(separator)

      open("| tail -f #{path}").each do |line|
        value = converted_str_for_logging(line)
        FluentCasualAgent.channel << "#{tag}#{separator}#{value}"
      end
    end

    def converted_str_for_logging(str)
      str = unescape_entity(str)
      str = strip_ansi_sequence(str)
      strip_eof(str)
    end

    private
    def strip_eof(str)
      str.gsub(/\n/, "")
    end

    def strip_ansi_sequence(str)
      str.gsub(/\e\[.*?m/, "")
    end

    def unescape_entity(str)
      str.gsub(/#{Regexp.union(ENTITY_MAP.keys)}/o) { |key| ENTITY_MAP[key] }
    end
  end
end
