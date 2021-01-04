require 'pony'
require 'dotenv/load'

class SendNewsletter
  TEMPORARY_ARTICLES_DIRECTORY = "./articles"

  def call
    save_html_files(Article.take(3))
    send_newsletter
    delete_html_files
  end

  def delete_html_files
    FileUtils.remove_dir(TEMPORARY_ARTICLES_DIRECTORY) if File.exist?(TEMPORARY_ARTICLES_DIRECTORY)
  end

  def save_html_files(articles)
    delete_html_files

    articles.each do |article|
      path = File.join(TEMPORARY_ARTICLES_DIRECTORY)

      FileUtils.mkdir_p(path) unless File.exist?(path)
      File.open(File.join(path, "#{article.title}.html"), "w") {|file| file.write(article.html) }
    end
  end

  def send_newsletter
    Pony.mail to:      ENV["target_email_address"],
              subject: "Here are your articles",
              body:    '',
              via:     :smtp,
              via_options: {
                address:        'smtp.gmail.com',
                port:           '587',
                user_name:      ENV['application_email_user_name'],
                password:       ENV['application_email_password'],
                authentication: :plain,
                domain:         "gmail.com",
              },
              attachments: attachments
  end

  def attachments
    attachments = {}
    pn = Pathname(TEMPORARY_ARTICLES_DIRECTORY)
    pn.children.each do |filename|
      attachments.merge!({filename.basename.to_s => File.read(filename.to_path)})
    end
    attachments
  end
end
