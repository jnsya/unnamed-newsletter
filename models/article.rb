# frozen_string_literal: true

# An Article represents... an article. Scraped from some online publication with the download method.
# It contains a title, a URL, and the raw HTML taken from that URL.
class Article < ActiveRecord::Base
  scope :unsent, -> { where(sent: nil) }

  def download
    self.html = URI.parse(url).read
  rescue OpenURI::HTTPError
    puts "Article failed to download: #{url}"
  end
end
