class PaymentHeader < ActiveRecord::Base
  validates :description, presence: :true
  validates :payment_date, presence: :true
  validates :currency, presence: :true
  validates :amount, presence: :true
  validates :payment_status, presence: :true

  belongs_to :currency, :class_name => 'Currency', :foreign_key => :currency_id
  belongs_to :payment_status, :class_name => 'PaymentStatus', :foreign_key => :payment_status_id
end
