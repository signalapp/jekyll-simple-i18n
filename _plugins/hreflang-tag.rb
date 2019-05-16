module Jekyll

  class HreflangTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      page = context.environments.first["page"]
      site = context.registers[:site]

      if page["translate"]
        dir       = page["src_dir"].nil? ? page["dir"] : page["src_dir"]
        hreflangs = %{<link rel="alternate" hreflang="en" href="#{site.config["url"]}#{dir}" />}

        site.data["languages"].each_key do |language|
          hreflangs << %{<link rel="alternate" hreflang="#{language.tr('_', '-')}" href="#{site.config["url"]}/#{language}#{dir}" />}
        end
      end

      hreflangs
    end
  end

end

Liquid::Template.register_tag('hreflang', Jekyll::HreflangTag)
