require 'open-uri'
require 'nokogiri'

class ScrapeLongform
  def initialize(http_client: URI, url: 'https://longform.org/best')
    self.http_client = http_client
    self.url = url
  end

  def call
    index_page = Nokogiri::HTML(http_client.open(url))
    get_articles(index_page)
  end

  private

  attr_accessor :http_client, :url

  def get_articles(index_page)
    articles = []

    index_page.css(".post__title").each do |element|
      url = element.parent.attributes["href"].value
      title = element.children.children.to_s.strip
      articles << { url: url, title: title }
    end

    articles
  end
end
