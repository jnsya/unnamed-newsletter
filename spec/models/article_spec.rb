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
end
