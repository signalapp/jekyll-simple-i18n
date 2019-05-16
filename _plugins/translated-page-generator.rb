module Jekyll

  class TranslatedPage < Page
    def initialize(site, base, dir, name)
      @site, @base, @dir, @name = site, base, dir, name

      self.process(@name)
      self.data ||= {}
    end
  end

  class TranslatedPageGenerator < Generator
    def generate(site)
      pages_to_translate = site.pages.select { |page| page.data["translate"] }

      pages_to_translate.each do |page|
        page_title              = page.data['title']
        page_title_transifex_id = Transifex::ID.get(page_title)

        Transifex::SourceFile.add_entry(page_title_transifex_id, page_title)

        site.data["languages"].each_key do |language|
          translated_page       = Jekyll::TranslatedPage.new(site, site.source, page.dir, page.name)
          translated_page_title = site.data["languages"][language][page_title_transifex_id]

          translated_page.data              = page.data.clone
          translated_page.data['title']     = translated_page_title.nil? ? page_title : translated_page_title.strip
          translated_page.data['permalink'] = "#{language}/#{page.dir}/#{page.name}"
          translated_page.data['src_dir']   = page.dir
          translated_page.data['language']  = language
          translated_page.content           = page.content

          site.pages << translated_page
        end
      end
    end
  end

end
