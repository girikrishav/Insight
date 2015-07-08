class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :description
      t.date :payment_date
      t.decimal :amount
      t.string :comments
      t.integer :currency_id
      t.integer :payment_status_id

      t.timestamps
    end
  end
end
