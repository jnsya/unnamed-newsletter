require './services/get_new_articles'
require 'webmock/rspec'

RSpec.describe GetNewArticles do
  before do
    stub_request(:get, "https://www.example_1.com").to_return(body: "<h1>Great Article</h1>")
    stub_request(:get, "https://www.example_2.com").to_return(body: "<h1>Fantastic Piece</h1>")
  end

  it 'saves valid articles and rejects articles when their URLs already exist' do
    existing_article   = Article.new(url: "https://www.example_1.com", title: "Stunning New Insight")
    unique_article     = Article.new(url: "https://www.example_2.com", title: "Thrilling Narrative Non-Fiction")
    scraper            = instance_double(ScrapeLongform, call: [existing_article, unique_article])
    existing_article.save!

    expect { GetNewArticles.new(scrapers: [scraper]).call }.to change { Article.count }.from(1).to(2)

    expect(Article.all).to match_array([existing_article, unique_article])
  end

  it 'saves the HTML of new articles' do
    article = Article.new(url: "https://www.example_1.com", title: "example")
    scraper = instance_double(ScrapeLongform, call: [article])

    GetNewArticles.new(scrapers: [scraper]).call

    expect(article.html).to eq("<h1>Great Article</h1>")
  end

  it 'handles articles with missing titles gracefully' do
  end

  it 'handles articles with missing URLs gracefully' do
  end
end
