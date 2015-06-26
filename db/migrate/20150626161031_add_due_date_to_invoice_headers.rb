class AddDueDateToInvoiceHeaders < ActiveRecord::Migration
  def change
    add_column :invoice_headers, :due_date, :date
  end
end
