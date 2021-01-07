# frozen_string_literal: true

require './services/send_newsletter'
require './models/recipient'

RSpec.describe SendNewsletter do
  before do
    configure_email_for_testing
  end

  it 'sends 1 email with 3 articles to the correct email address' do
    Article.create(html: '<h1>Hi!</h1>', url: 'Something', title: 'Stunning New Insight')
    Article.create(html: '<h1>Hi!</h1>', url: 'Something', title: 'Another Fabulous Piece')
    Article.create(html: '<h1>Hi!</h1>', url: 'Something', title: 'Wow! What an article')
    Article.create(html: '<h1>Hi!</h1>', url: 'Something', title: 'Real good stuff')

    expect { SendNewsletter.new.call }.to change { Mail::TestMailer.deliveries.length }.from(0).to(1)

    email = Mail::TestMailer.deliveries.first
    expect(email.to).to                eq(['example@example.com'])
    expect(email.attachments.count).to eq(3)
  end

  it 'sends the correct contents of an article' do
    Article.create(html: '<h1>Cool title</h1>', url: 'Something', title: 'Stunning New Insight')

    expect { SendNewsletter.new.call }.to change { Mail::TestMailer.deliveries.length }.from(0).to(1)

    email = Mail::TestMailer.deliveries.first
    expect(email.attachments.count).to                 eq(1)
    expect(email.attachments.first.filename).to        eq('Stunning New Insight.txt')
    expect(email.attachments.first.body.raw_source).to eq('Cool title')
  end

  it 'sends an email to multiple recipients' do
    Article.create(html: '<h1>Cool title</h1>', url: 'Something', title: 'Stunning New Insight')
    Recipient.create(device_email: 'another_example@example.com', password: 'something')

    expect { SendNewsletter.new.call }.to change { Mail::TestMailer.deliveries.length }.from(0).to(2)

    expect(Mail::TestMailer.deliveries.first.to).to  eq(['example@example.com'])
    expect(Mail::TestMailer.deliveries.second.to).to eq(['another_example@example.com'])
  end

  it 'deletes the local versions of article attachments after sending the email' do
    Article.create(html: '<h1>Cool title</h1>', url: 'Something', title: 'Stunning New Insight')

    expect { SendNewsletter.new.call }.to change { Mail::TestMailer.deliveries.length }.from(0).to(1)

    expect(File.exist?('./articles')).to eq(false)
  end

  def configure_email_for_testing
    Recipient.create(device_email: 'example@example.com', password: 'something')
    Pony.override_options = { via: :test }
    Mail::TestMailer.deliveries.clear
  end
end
