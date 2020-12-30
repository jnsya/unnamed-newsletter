class ScrapeLongformBest
  def initialize(uri_parser: Uri.open, html_parser: Nokogiri::HTML, url: 'https://longform.org/best')
    self.uri_parser = uri_parser
    self.html_parser = html_parser
    self.url = url
  end

  def call
    articles_index_page = html_parser(uri_parser(url))
    all_links = articles_index_page.css('div article a').map { |link| link['href'] }

    external_article_links = all_links.select do |url|
      url.include?("https") && !url.include?("longform.org")
    end.uniq
  end

  private

  attr_reader :uri_parser, :html_parser, :url
end
