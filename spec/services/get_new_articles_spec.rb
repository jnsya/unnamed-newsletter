require './services/get_new_articles'

RSpec.describe GetNewArticles do
  subject(:service)       { GetNewArticles.new(scrapers: [scraper]) }
  let(:scraper)           { instance_double(ScrapeLongform, call: [duplicated_article, unique_article]) }
  let(:duplicated_article) { Article.new(url: "not unique", title: "example") }
  let(:unique_article)     { Article.new(url: "unique", title: "example") }

  it 'saves valid articles and rejects articles when their URLs already exist' do
    duplicated_article.save!

    expect { service.call }.to change { Article.count }.from(1).to(2)

    expect(Article.all).to match_array([duplicated_article, unique_article])
  end
end
