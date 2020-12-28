require 'open-uri'
require 'nokogiri'
require 'pry'
require 'pony'
require 'dotenv/load'

def fetch_article_links(articles_index_url)
  articles_uri = URI.open(articles_index_url)
  articles_index_page = Nokogiri::HTML(articles_uri)
  all_links = articles_index_page.css('div article a').map{ |link| link['href'] }

  external_article_links = all_links.select do |url|
    url.include?("https") && !url.include?("longform.org")
  end.uniq
end

def fetch_article_html(url)
  Nokogiri::HTML(URI.open(url))
end

def send_to_kindle(filenames)
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
            :attachments          => { "example.html" => File.read("example.html"), "example2.html" => File.read("example2.html"), "example3.html" => File.read("example3.html"), "example4.html" => File.read("example4.html") }
end

def random_string
  (0...8).map { (65 + rand(26)).chr }.join
end

def save_html_files(links)
  links.each do |link|
    html = fetch_article_html(link)
    File.open("#{random_string}.html", "w") {|file| file.write(html) }
  end
end

links = fetch_article_links('https://longform.org/best')
save_html_files(links)
