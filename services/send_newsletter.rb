require 'pony'
require 'dotenv/load'
require 'html2text'

class SendNewsletter
  TEMPORARY_ARTICLES_DIRECTORY = "./articles"

  def call
    save_temporary_email_attachments(Article.take(3))
    send_newsletter
    delete_temporary_email_attachments
  end

  def save_temporary_email_attachments(articles)
    delete_temporary_email_attachments

    articles.each do |article|
      text = Html2Text.convert(article.html)
      path = File.join(TEMPORARY_ARTICLES_DIRECTORY)

      FileUtils.mkdir_p(path) unless File.exist?(path)
      File.open(File.join(path, "#{article.title}.txt"), "w") {|file| file.write(text) }
    end
  end

  def send_newsletter
    Recipient.all.each do |recipient|
      send_email(recipient.device_email)
    end
  end

  def send_email(email_address)
    Pony.mail to: email_address,
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

  def delete_temporary_email_attachments
    FileUtils.remove_dir(TEMPORARY_ARTICLES_DIRECTORY) if File.exist?(TEMPORARY_ARTICLES_DIRECTORY)
  end
end
