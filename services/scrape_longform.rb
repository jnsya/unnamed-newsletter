# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'sinatra/activerecord'
require './models/article'

# Service object that scrapes a given URL on the site `Longform.org`,
# and returns a collection of Article objects.
class ScrapeLongform
  def initialize(http_client: URI, url: 'https://longform.org/best')
    self.http_client = http_client
    self.url = url
  end

  def call
    index_page = Nokogiri::HTML(http_client.open(url))
    parse_articles(index_page)
  end

  private

  attr_accessor :http_client, :url

  def parse_articles(index_page)
    index_page.css('.post__title').map do |element|
      url   = element.parent.attributes['href'].value
      title = element.children.children.to_s.strip

      Article.new(url: url, title: title)
    end
  end
end
