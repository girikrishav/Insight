class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :name
      t.string :description
      t.integer :days
      t.string :comments

      t.timestamps
    end
  end
end
