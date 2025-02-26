module Jekyll
  class AutoDescriptionGenerator < Generator
    priority :low

    def generate(site)
      site.pages.each do |page|
        match = page.content.to_s.match(/<p>(.*?)<\/p>/m)

        if match
          page.data['description'] = match[1]
          page.content.sub!(match[0], '')
        end
      end
    end
  end
end
