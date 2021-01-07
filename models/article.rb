# frozen_string_literal: true

# An Article represents a piece of journalism.
# It contains a title, a URL, and the raw HTML taken from that URL.
class Article < ActiveRecord::Base
  def download
    self.html = URI.parse(url).read
  rescue OpenURI::HTTPError
    puts "Article failed to download: #{url}"
  end
end
