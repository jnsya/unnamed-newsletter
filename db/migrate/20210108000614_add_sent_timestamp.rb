# frozen_string_literal: true

class AddSentTimestamp < ActiveRecord::Migration[6.1]
  def change
    change_table :articles do |t|
      t.datetime :sent
    end
  end
end
