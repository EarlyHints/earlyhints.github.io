module Jekyll
  class AutoDescriptionGenerator < Generator
    priority :low  # Runs after other generators

    def generate(site)
      site.pages.each do |page|
        # Skip if front matter already has a description
        next if page.data['description']

        # Find first paragraph
        match = page.content.to_s.match(/<p>(.*?)<\/p>/m)

        if match
          # Set the description
          page.data['description'] = match[1]
          
          # Remove the first paragraph from content
          page.content.sub!(match[0], '')
        end
      end
    end
  end
end
