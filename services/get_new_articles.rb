class GetNewArticles
  def initialize(scrapers: [ScrapeLongform.new])
    scrapers = scrapers
  end

  def call
    scrapers.flat_map(&:call).reject do |article|
      Article.find_by(url: article.url).present?
    end.each(&:save!)
  end

  private

  attr_reader :scrapers
end
