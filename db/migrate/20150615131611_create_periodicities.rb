class CreatePeriodicities < ActiveRecord::Migration
  def change
    create_table :periodicities do |t|
      t.string :name
      t.string :description
      t.decimal :days
      t.decimal :rank
      t.string :comments

      t.timestamps
    end
  end
end
