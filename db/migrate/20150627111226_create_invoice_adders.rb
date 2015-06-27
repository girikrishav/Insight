class CreateInvoiceAdders < ActiveRecord::Migration
  def change
    create_table :invoice_adders do |t|
      t.string :description
      t.decimal :amount
      t.string :comments
      t.integer :invoice_header_id
      t.integer :invoice_adder_type_id

      t.timestamps
    end
  end
end
