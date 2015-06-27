class InvoiceAdder < ActiveRecord::Base
  def line_type_check
    if self.description.nil? and self.invoice_adder_type_id.nil?
      errors.add(:description, I18n.t('errors.invoice_adder_type_all_blank'))
      errors.add(:invoice_adder_type_id, I18n.t('errors.invoice_adder_type_all_blank'))
    elsif !self.description.nil?
      if !self.invoicing_milestone_id.nil?
        errors.add(:invoicing_milestone_id, I18n.t('errors.invoice_adder_type_description_check'))
      end
    elsif !self.invoicing_milestone_id.nil?
      if !self.description.nil?
        errors.add(:description, I18n.t('errors.invoice_adder_type_invoice_adder_type_check'))
      end
    end
  end

  validates :amount, presence: :true
  validates :invoice_header_id, presence: :true
  validates :invoice_adder_type_id, presence: :true

  validate :line_type_check

  belongs_to 'invoice_header', class_name: 'InvoiceHeader', foreign_key: :invoice_header_id
  belongs_to 'invoice_adder_type', class_name: 'InvoiceAdderType', foreign_key: :invoice_adder_type_id
end
