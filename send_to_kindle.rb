require 'pry'
require 'pony'
require 'dotenv/load'
require 'html2text'
require 'sinatra/activerecord'
require './services/get_new_articles'
require './services/scrape_longform'
require './models/article'

def send_to_kindle(attachments)
  Pony.mail :to => ENV["target_email_address"],
            :subject => "Here are your articles",
            :body => '',
            :via => :smtp,
            :via_options => {
                :address              => 'smtp.gmail.com',
                :port                 => '587',
                :user_name            => ENV['application_email_user_name'],
                :password             => ENV['application_email_password'],
                :authentication       => :plain,
                :domain               => "gmail.com",
            },
            :attachments          => attachments
end

def random_string
  (0...8).map { (65 + rand(26)).chr }.join
end

def save_html_files(links)
  links.each do |link|
    html = fetch_article_html(link)
    path = File.join(".", "articles")

    FileUtils.mkdir_p(path) unless File.exist?(path)
    File.open(File.join(path, "#{random_string}.html"), "w") {|file| file.write(html) }
  end
end

def save_plaintext_files
  pn = Pathname("./articles")
  pn.children.each do |path|
    text = Html2Text.convert(File.read(path))
    File.open(path, "w") {|file| file.write(text) }
    File.rename(path, "whatver.txt")
  end
end

def attachments
  attachments = {}
  pn = Pathname("./articles")
  pn.children.each do |path|
    attachments.merge!({path.basename.to_s => File.read(path.to_path)})
  end
  attachments
end

links = GetNewArticles.new.call
save_html_files(links)
send_to_kindle(attachments)
# delete_html_files
save_plaintext_files
