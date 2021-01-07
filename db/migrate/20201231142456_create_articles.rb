# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.text :html

      t.timestamps
    end
  end
end
