# frozen_string_literal: true

# A Recipient is a user who has signed up for the newsletter.
# We store the email address that we'll send the newsletter to, and their password.
class Recipient < ActiveRecord::Base
  has_secure_password
  validates :device_email, presence: true, uniqueness: true
end
