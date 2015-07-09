class PaymentLine < ActiveRecord::Base
  validates :amount, presence: :true
  validates :payment_header, presence: :true

  belongs_to :payment_header, class_name: 'PaymentHeader', foreign_key: :payment_header_id
  belongs_to :invoice_header, class_name: 'InvoiceHeader', foreign_key: :invoice_header_id
end
