# frozen_string_literal: true

require 'html2text'

# An Article represents... an article. Scraped from some online publication with the download method.
# It contains a title, a URL, and the raw HTML taken from that URL.
# The `html2text` gem is used to extract the text content of the article from its HTML.
class Article < ActiveRecord::Base
  scope :unsent, -> { where(sent: nil) }

  def text
    Html2Text.convert(html)
  end

  def download
    self.html = URI.parse(url).read
  rescue OpenURI::HTTPError
    puts "Article failed to download: #{url}"
  end
end
