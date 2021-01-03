require 'pry'
class Article < ActiveRecord::Base
  def download
    self.html = URI.parse(url).read
    save!
  end
end
