# frozen_string_literal: true

require 'bcrypt'

# A Recipient is a user who has signed up for the newsletter.
# We store the email address that we'll send the newsletter to, and their password.
class Recipient < ActiveRecord::Base
  include BCrypt

  has_secure_password
  validates :device_email, presence: true, uniqueness: true

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end
end
