# frozen_string_literal: true

require './services/scrape_longform'

RSpec.describe ScrapeLongform do
  subject(:service) { ScrapeLongform.new }
  let(:articles_index_page) { File.read('./spec/fixtures/longform/articles_index.html') }

  it 'returns the correct number of articles' do
    expect(URI).to receive(:open).and_return(articles_index_page)
    result = subject.call

    expect(result.size).to eq(25)
  end

  it 'returns an article\'s URL and title' do
    expect(URI).to receive(:open).and_return(articles_index_page)
    result = subject.call

    expect(result.first.url).to   eq('http://www.si.com/vault/2016/06/13/rapture-deep-carried-away-love-risk-and-each-other-two-worlds-best-freedivers-went-limits-their')
    expect(result.first.title).to eq('Rapture of the Deep')
    expect(result.first.html).to  eq(nil)
  end
end
