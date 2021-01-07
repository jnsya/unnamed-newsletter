class Recipient < ActiveRecord::Base
  has_secure_password
  validates :device_email, presence: true, uniqueness: true
end
