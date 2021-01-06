class Article < ActiveRecord::Base
  def download
    begin
      self.html = URI.parse(url).read
    rescue OpenURI::HTTPError
      puts "Article failed to download: #{url}"
    end
  end
end
