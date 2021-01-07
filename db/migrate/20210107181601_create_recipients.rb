class CreateRecipients < ActiveRecord::Migration[6.1]
  def change
    create_table :recipients do |t|
      t.string :device_email, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
