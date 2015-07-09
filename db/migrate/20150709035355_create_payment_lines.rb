class CreatePaymentLines < ActiveRecord::Migration
  def change
    create_table :payment_lines do |t|
      t.string :description
      t.decimal :amount
      t.string :comments
      t.integer :payment_header_id
      t.integer :invoice_header_id

      t.timestamps
    end
  end
end
