module Transifex

  class ID
    def self.get(source_text)
      source_text.strip.gsub(/[^\w\d\s]/, '').tr(' ', '_').downcase
    end
  end

  class SourceFile
    class << self
      def add_entry(transifex_id, source_text)
        unless id_already_exists?(transifex_id)
          new_entry = <<-YAML
#{transifex_id}: |
  #{source_text}

          YAML

          File.write(transifex_source_location, new_entry, mode: 'a')
        end
      end

      def id_already_exists?(transifex_id)
        File.readlines(transifex_source_location).grep(/^#{transifex_id}: \|$/).any?
      end

      def refresh
        File.write(transifex_source_location, "---\n")
      end

      def transifex_source_location
        "#{__dir__}/../transifex-source-file.yml"
      end
    end
  end

end

Jekyll::Hooks.register :site, :after_init do
  Transifex::SourceFile.refresh
end
