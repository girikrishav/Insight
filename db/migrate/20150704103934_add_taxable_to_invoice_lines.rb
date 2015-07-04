class AddTaxableToInvoiceLines < ActiveRecord::Migration
  def change
    add_column :invoice_lines, :taxable, :boolean
  end
end
