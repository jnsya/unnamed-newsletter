require './services/send_newsletter'

RSpec.describe SendNewsletter do
  before do
    configure_email_for_testing
  end

  it "sends 1 email with 3 articles to the correct email address" do
    Article.create(html: "<h1>Hi!</h1>", url: "Something", title: "Stunning New Insight")
    Article.create(html: "<h1>Hi!</h1>", url: "Something", title: "Another Fabulous Piece")
    Article.create(html: "<h1>Hi!</h1>", url: "Something", title: "Wow! What an article")
    Article.create(html: "<h1>Hi!</h1>", url: "Something", title: "Real good stuff")

    expect { SendNewsletter.new.call }.to change { Mail::TestMailer.deliveries.length }.from(0).to(1)

    email = Mail::TestMailer.deliveries.first
    expect(email.subject).to           eq("Here are your articles")
    expect(email.to).to                eq(["example@example.com"])
    expect(email.attachments.count).to eq(3)
  end

  it "sends the correct contents of an article" do
    Article.create(html: "<h1>Cool title</h1>", url: "Something", title: "Stunning New Insight")

    expect { SendNewsletter.new.call }.to change { Mail::TestMailer.deliveries.length }.from(0).to(1)

    email = Mail::TestMailer.deliveries.first
    expect(email.attachments.count).to                 eq(1)
    expect(email.attachments.first.filename).to        eq("Stunning New Insight.html")
    expect(email.attachments.first.body.raw_source).to eq("<h1>Cool title</h1>")
  end

  it "removes the article attachments after sending the email" do
    Article.create(html: "<h1>Cool title</h1>", url: "Something", title: "Stunning New Insight")

    expect { SendNewsletter.new.call }.to change { Mail::TestMailer.deliveries.length }.from(0).to(1)

    expect(File.exist?("./articles")).to eq(false)
  end

  def configure_email_for_testing
    ENV["target_email_address"] = "example@example.com"
    Pony.override_options = { via: :test }
    Mail::TestMailer.deliveries.clear
  end
end