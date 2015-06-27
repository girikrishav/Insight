class RemoveInvoiceAdderTypeIdFromInvoiceLines < ActiveRecord::Migration
  def change
    remove_column :invoice_lines, :invoice_adder_type_id
  end
end
