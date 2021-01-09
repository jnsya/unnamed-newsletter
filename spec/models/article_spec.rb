# frozen_string_literal: true

require './models/article'

RSpec.describe Article do
  describe '.unsent' do
    it 'returns unsent articles' do
      _sent   = Article.create(title: 'something', url: 'something', sent: Time.current)
      unsent  = Article.create(title: 'something', url: 'something', sent: nil)

      expect(Article.unsent).to eq [unsent]
    end
  end

  describe '.text' do
    it 'converts an article\'s HTML into text, correctly handling formatting errors' do
      html = '<div><div><div><aside><p>With a man slipping into the ocean next month off Miami Beach, about to enter a trap where he can&apos;t breathe, speak, see or smell.</p><div><div><div><aside><p>'
      expected_text = "With a man slipping into the ocean next month off Miami Beach, about to enter a trap where he can't breathe, speak, see or smell."
      article = Article.create(title: 'something', url: 'something', html: html)

      expect(article.text).to eq(expected_text)
    end
  end
end
