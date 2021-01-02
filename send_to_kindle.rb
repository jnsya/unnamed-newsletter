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

def attachments
  attachments = {}
  pn = Pathname("./articles")
  pn.children.each do |path|
    attachments.merge!({path.basename.to_s => File.read(path.to_path)})
  end
  attachments
end
