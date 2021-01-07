# frozen_string_literal: true

require './services/scrape_longform'

# A service object that initiates the scraping of articles from various sources,
# rejects any articles that already exist, then downloads and saves the new ones.
# The service is called once a day.
class GetNewArticles
  def initialize(scrapers: [ScrapeLongform.new])
    self.scrapers = scrapers
  end

  def call
    scrapers
      .flat_map(&:call)
      .reject { |article| Article.find_by(url: article.url).present? }
      .each do |article|
        article.download
        article.save!
      end
  end

  private

  attr_accessor :scrapers
end
