module FluentCasualAgent
  module Tail
    extend self

    ENTITY_MAP = {
      "&lt;" => "<",
      "&gt;" => ">",
    }

    def run(target)
      open("| tail -f #{target[:path]}").each do |l|
        l = unescape_entity(l)
        l = strip_ansi_sequence(l)
        l = strip_eof(l)
        FluentCasualAgent.channel << "#{target[:tag]},#{l}"
      end
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
