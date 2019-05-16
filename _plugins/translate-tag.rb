module Jekyll

  class TranslateTag < Liquid::Tag
    attr_reader :text, :transifex_id

    def initialize(tag_name, text, tokens)
      super
      @text         = text.strip
      @transifex_id = Transifex::ID.get(text)
    end

    def render(context)
      page_language = context.environments.first["page"]["language"]

      if page_language.nil?
        Transifex::SourceFile.add_entry(transifex_id, text)

        text
      else
        liquid = <<-H2O
{%- assign translated_string = site.data.languages.#{page_language}.#{transifex_id} -%}
{%- if translated_string -%}
{{ translated_string | strip_newlines }}
{%- else -%}
#{text}
{%- endif -%}
        H2O

        Liquid::Template.parse(liquid).render(context)
      end
    end
  end

end

Liquid::Template.register_tag('translate', Jekyll::TranslateTag)
