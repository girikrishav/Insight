class CreateInvoiceHeaders < ActiveRecord::Migration
  def change
    create_table :invoice_headers do |t|
      t.string :description
      t.date :invoice_date
      t.string :comments
      t.integer :project_id
      t.integer :invoice_status_id
      t.integer :term_id

      t.timestamps
    end
  end
end
