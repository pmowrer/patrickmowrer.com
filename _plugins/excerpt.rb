# Based on: http://www.jacquesf.com/2011/03/creating-excerpts-in-jekyll-with-wordpress-style-more-html-comments/

module Excerpt
  def excerptfilter(input)
    if input.include? "<!--break-->"
      input.split("<!--break-->").first
    else
      input
    end
  end
end

Liquid::Template.register_filter(Excerpt)
