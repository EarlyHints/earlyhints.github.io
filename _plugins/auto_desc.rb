module Jekyll
  class AutoDescriptionGenerator < Generator
    priority :low

    def generate(site)
      (site.pages + site.posts.docs).each do |page|
        content = page.content.to_s
        content = Jekyll::Converters::Markdown.new(site.config).convert(content) unless content.include?("<p>")

        match = content.match(/<p>(.*?)<\/p>/m)
        if match
          page.data['description'] = match[1].strip
          page.content.sub!(match[0], '')
        end
      end
    end
  end
end
