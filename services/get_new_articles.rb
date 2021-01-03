require './services/scrape_longform'

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
