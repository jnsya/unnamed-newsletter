require 'open-uri'
require 'nokogiri'
require 'pry'

def fetch_article_links(articles_index_url)
  articles_index_page = Nokogiri::HTML(URI.open(articles_index_url))
  all_links = articles_index_page.css('div article a').map{ |link| link['href'] }

  external_article_links = all_links.select do |url|
    url.include?("https") && !url.include?("longform.org")
  end.uniq
end

fetch_article_links('https://longform.org/best')
